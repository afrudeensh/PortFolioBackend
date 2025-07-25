package com.sha.controller;

import com.sha.request.ContactRequest;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/contact")
@CrossOrigin(origins = "*")
public class ContactController {

    @Autowired
    private JavaMailSender mailSender;

    @PostMapping("/send")
    public ResponseEntity<?> sendMessage(@Valid @RequestBody ContactRequest request) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setTo("afrudeenhasina15301@gmail.com");
            message.setSubject("New Message from Portfolio");
            message.setText(
                    "Name: " + request.getName() + "\n" +
                            "Email: " + request.getEmail() + "\n\n" +
                            "Message:\n" + request.getMessage()
            );

            mailSender.send(message);

            return ResponseEntity.ok("Message sent successfully");
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Message Failed to send");
        }
    }
}
