import api from './client'

export default {
  // ✅ Login API
  login: (username, password) =>
    api.post('/auth/login.php', { username, password }),

  // ✅ Logout — លុប Local Storage
  logout: () => {
    localStorage.removeItem('user')
    localStorage.removeItem('token')
  },

  // ✅ ពិនិត្យ Login
  isLoggedIn: () => !!localStorage.getItem('user'),

  // ✅ ទាញ User Data
  getUser: () => {
    const u = localStorage.getItem('user')
    return u ? JSON.parse(u) : null
  }
}