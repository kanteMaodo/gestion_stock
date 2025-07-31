package org.example.gestionpharmacie.model;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class TestConnection {

    public static void main(String[] args) {
        try {
            EntityManagerFactory emf = Persistence.createEntityManagerFactory("PharmaPU");
            EntityManager em = emf.createEntityManager();

            System.out.println(" Connexion réussie à PostgreSQL !");
            System.out.println(" Table 'utilisateurs' sera créée automatiquement");

            em.close();
            emf.close();
        } catch (Exception e) {
            System.err.println("Erreur de connexion : " + e.getMessage());
            e.printStackTrace();
        }
    }
}
