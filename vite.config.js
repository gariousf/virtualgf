import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    host: true // Allow access from network
  },
  preview: {
    host: true, // Allow access from network
    port: 4173, // Default preview port, ensure it matches Dockerfile EXPOSE
    allowedHosts: [
      'virtualgf-tpr2.onrender.com',
      // Add any other allowed hosts here, e.g., localhost for local testing
      'localhost'
    ],
  },
})
