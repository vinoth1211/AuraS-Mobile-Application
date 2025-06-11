const functions = require('firebase-functions');
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');
const twilio = require('twilio');

// Initialize Firebase
admin.initializeApp();

// Email setup (using Gmail)
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: functions.config().gmail.email,
    pass: functions.config().gmail.password,
  },
});

// Twilio setup
const twilioClient = twilio(
  functions.config().twilio.sid,
  functions.config().twilio.token
);

// Send email to dermatologist when appointment is booked
exports.notifyDermatologist = functions.firestore
  .document('appointments/{appointmentId}')
  .onCreate(async (snapshot, context) => {
    try {
      const appointment = snapshot.data();

      // Get dermatologist data
      const dermDoc = await admin.firestore()
        .collection('dermatologists')
        .doc(appointment.dermatologistId)
        .get();

      if (!dermDoc.exists) {
        console.error('Dermatologist not found');
        return;
      }

      const dermatologist = dermDoc.data();

      // Format appointment date
      const appointmentDate = appointment.date.toDate();
      const formattedDate = appointmentDate.toLocaleDateString('en-US', {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      });

      // Prepare email
      const mailOptions = {
        from: 'AuraS Skincare <noreply@auras.com>',
        to: dermatologist.email,
        subject: 'New Appointment Request - Action Required',
        html: `
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <h2 style="color: #004237;">New Appointment Request</h2>
            <p>You have a new appointment request from ${appointment.userName}.</p>

            <div style="background-color: #f8f9fa; padding: 20px; border-radius: 8px; margin: 20px 0;">
              <p><strong style="color: #004237;">📅 Date:</strong> ${formattedDate}</p>
              <p><strong style="color: #004237;">⏰ Time:</strong> ${appointment.time}</p>
              <p><strong style="color: #004237;">👤 Patient:</strong> ${appointment.userName}</p>
              <p><strong style="color: #004237;">📞 Phone:</strong> ${appointment.userPhone}</p>
              <p><strong style="color: #004237;">✉️ Email:</strong> ${appointment.userEmail}</p>
            </div>

            <p>Please login to the admin panel to confirm or reject this appointment:</p>
            <a href="https://your-admin-panel.com/appointments"
              style="display: inline-block; padding: 12px 24px; background-color: #004237;
                    color: white; text-decoration: none; border-radius: 4px; margin-top: 15px;">
              View Appointment
            </a>

            <p style="margin-top: 30px; color: #6c757d; font-size: 14px;">
              This is an automated message. Please do not reply directly to this email.
            </p>
          </div>
        `,
      };

      // Send email
      await transporter.sendMail(mailOptions);
      console.log('Notification email sent to dermatologist');

    } catch (error) {
      console.error('Error sending dermatologist notification:', error);
    }
  });

// Send WhatsApp when appointment is confirmed
exports.sendWhatsAppConfirmation = functions.firestore
  .document('appointments/{appointmentId}')
  .onUpdate(async (change, context) => {
    try {
      const before = change.before.data();
      const after = change.after.data();

      // Check if status changed to 'confirmed'
      if (before.status !== 'confirmed' && after.status === 'confirmed') {
        let userPhone = after.userPhone;

        // Clean and format phone number
        userPhone = userPhone.replace(/\D/g, '');

        // Add country code for Sri Lanka if missing
        if (userPhone.startsWith('0') && userPhone.length === 10) {
          userPhone = '94' + userPhone.substring(1);
        }

        const formattedPhone = `whatsapp:+${userPhone}`;

        // Format appointment date
        const appointmentDate = after.date.toDate();
        const formattedDate = appointmentDate.toLocaleDateString('en-US', {
          weekday: 'long',
          year: 'numeric',
          month: 'long',
          day: 'numeric'
        });

        // Create WhatsApp message
        const message = `✅ Your appointment with Dr. ${after.dermatologistName} has been confirmed!\n\n` +
                        `📅 Date: ${formattedDate}\n` +
                        `⏰ Time: ${after.time}\n\n` +
                        `📍 Location: ${after.dermatologistLocation || 'Clinic Address'}\n\n` +
                        `We look forward to seeing you! Please arrive 10 minutes early.\n\n` +
                        `Reply STOP to unsubscribe`;

        // Send WhatsApp message
        await twilioClient.messages.create({
          body: message,
          from: 'whatsapp:+14155238886', // Your Twilio WhatsApp number
          to: formattedPhone,
        });

        console.log('WhatsApp confirmation sent to user');
      }
    } catch (error) {
      console.error('Error sending WhatsApp confirmation:', error);
    }
  });

// Optional: Function to handle appointment cancellations
exports.notifyAppointmentCancellation = functions.firestore
  .document('appointments/{appointmentId}')
  .onUpdate(async (change, context) => {
    try {
      const before = change.before.data();
      const after = change.after.data();

      // Check if appointment was canceled
      if (before.status !== 'canceled' && after.status === 'canceled') {
        // Get dermatologist data
        const dermDoc = await admin.firestore()
          .collection('dermatologists')
          .doc(after.dermatologistId)
          .get();

        if (!dermDoc.exists) return;

        const dermatologist = dermDoc.data();

        // Format appointment date
        const appointmentDate = after.date.toDate();
        const formattedDate = appointmentDate.toLocaleDateString('en-US', {
          weekday: 'long',
          year: 'numeric',
          month: 'long',
          day: 'numeric'
        });

        // Prepare email to dermatologist
        const mailOptions = {
          from: 'AuraS Skincare <noreply@auras.com>',
          to: dermatologist.email,
          subject: 'Appointment Canceled',
          html: `
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
              <h2 style="color: #004237;">Appointment Canceled</h2>
              <p>The following appointment has been canceled:</p>

              <div style="background-color: #f8f9fa; padding: 20px; border-radius: 8px; margin: 20px 0;">
                <p><strong style="color: #004237;">👤 Patient:</strong> ${after.userName}</p>
                <p><strong style="color: #004237;">📅 Date:</strong> ${formattedDate}</p>
                <p><strong style="color: #004237;">⏰ Time:</strong> ${after.time}</p>
              </div>

              <p style="margin-top: 30px; color: #6c757d; font-size: 14px;">
                This is an automated message. Please do not reply directly to this email.
              </p>
            </div>
          `,
        };

        // Send email
        await transporter.sendMail(mailOptions);
        console.log('Cancellation notification sent to dermatologist');
      }
    } catch (error) {
      console.error('Error handling cancellation:', error);
    }
  });