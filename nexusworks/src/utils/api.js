import axios from 'axios';

/**
 * Centralised axios instance.
 * In development, VITE_API_URL is usually empty and requests hit
 * "/api/..." which the Vite dev server proxies to the Express backend.
 * In production, set VITE_API_URL to your deployed API origin.
 */
const baseURL = import.meta.env.VITE_API_URL || '';

const api = axios.create({
  baseURL,
  headers: { 'Content-Type': 'application/json' },
  timeout: 15000,
});

/**
 * Submit a contact/query form.
 * @param {object} payload { name, email, phone, company, services[], budget, timeline, message }
 * @returns {Promise<{success:boolean, message?:string, id?:string, error?:string}>}
 */
export async function submitQuery(payload) {
  try {
    const { data } = await api.post('/api/queries', payload);
    return data;
  } catch (err) {
    const message =
      err.response?.data?.error ||
      err.response?.data?.errors?.[0]?.msg ||
      err.message ||
      'Something went wrong. Please try again.';
    return { success: false, error: message };
  }
}

export default api;
