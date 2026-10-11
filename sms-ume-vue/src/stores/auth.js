import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import authApi from '@/api/auth'

export const useAuthStore = defineStore('auth', () => {
  // ==================== STATE ====================
  const user = ref(authApi.getUser())
  const loading = ref(false)
  const error = ref('')

  // ==================== GETTERS ====================
  const isLoggedIn = computed(() => !!user.value)

  // ==================== ACTIONS ====================
  async function login(username, password) {
    loading.value = true
    error.value = ''

    try {
      const res = await authApi.login(username, password)

      if (res.success) {
        user.value = res.user
        localStorage.setItem('user', JSON.stringify(res.user))
        localStorage.setItem('token', res.token)
        return true
      } else {
        error.value = res.error || 'ឈ្មោះអ្នកប្រើ ឬលេខសម្ងាត់មិនត្រឹមត្រូវ'
        return false
      }
    } catch (e) {
      error.value = e.response?.data?.error || 'មានបញ្ហាក្នុងការ Login'
      return false
    } finally {
      loading.value = false
    }
  }

  function logout() {
    authApi.logout()
    user.value = null
  }

  return {
    user, loading, error, isLoggedIn,
    login, logout
  }
})