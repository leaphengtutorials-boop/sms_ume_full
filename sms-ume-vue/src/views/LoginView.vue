<template>
  <div class="login-page">
    <div class="login-card">
      <!-- Logo -->
      <div class="login-logo">
        <div class="logo-icon">📚</div>
        <h2>ប្រព័ន្ធគ្រប់គ្រងសិស្ស</h2>
        <p>Student Management System</p>
      </div>

      <!-- Form -->
      <form @submit.prevent="handleLogin">
        <div class="form-group">
          <label>👤 ឈ្មោះអ្នកប្រើ</label>
          <input
            v-model="username"
            type="text"
            class="input"
            placeholder="បំពេញឈ្មោះអ្នកប្រើ"
            required
            autofocus
          />
        </div>

        <div class="form-group">
          <label>🔒 លេខសម្ងាត់</label>
          <div class="password-input">
            <input
              v-model="password"
              :type="showPassword ? 'text' : 'password'"
              class="input"
              placeholder="បំពេញលេខសម្ងាត់"
              required
            />
            <button
              type="button"
              class="toggle-pass"
              @click="showPassword = !showPassword"
            >
              {{ showPassword ? '🙈' : '👁️' }}
            </button>
          </div>
        </div>

        <div v-if="auth.error" class="error-msg">
          ❌ {{ auth.error }}
        </div>

        <button type="submit" class="btn-login" :disabled="auth.loading">
          <span v-if="auth.loading">⏳ កំពុងចូល...</span>
          <span v-else>🚀 ចូលប្រើ</span>
        </button>

        <div class="login-info">
          <strong>Default Login:</strong><br />
          Username: <code>admin</code> · Password: <code>password</code>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useToastStore } from '@/stores/toast'

const router = useRouter()
const auth = useAuthStore()
const toast = useToastStore()

const username = ref('')
const password = ref('')
const showPassword = ref(false)

async function handleLogin() {
  const ok = await auth.login(username.value, password.value)
  if (ok) {
    toast.show('✅ ចូលប្រើជោគជ័យ', 'success')

    // ✅ ទាញ URL ដើមពី sessionStorage
    const redirect = sessionStorage.getItem('redirectAfterLogin') || '/'
    sessionStorage.removeItem('redirectAfterLogin')

    router.push(redirect)
  }
}
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #6366f1, #8b5cf6);
  padding: 2rem 1rem;
}

.login-card {
  background: white;
  border-radius: 20px;
  padding: 2.5rem;
  width: 100%;
  max-width: 420px;
  box-shadow: 0 25px 60px rgba(0, 0, 0, 0.3);
}

.login-logo {
  text-align: center;
  margin-bottom: 2rem;
}

.login-logo .logo-icon {
  font-size: 4rem;
  display: inline-block;
  margin-bottom: 0.5rem;
}

.login-logo h2 {
  font-size: 1.4rem;
  font-weight: 700;
  color: var(--dark);
  margin-bottom: 0.3rem;
}

.login-logo p {
  color: var(--gray);
  font-size: 0.85rem;
}

.form-group {
  margin-bottom: 1.2rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  font-size: 0.9rem;
  font-weight: 600;
  color: #475569;
}

.password-input {
  position: relative;
}

.toggle-pass {
  position: absolute;
  right: 0.8rem;
  top: 50%;
  transform: translateY(-50%);
  background: transparent;
  border: none;
  font-size: 1.2rem;
  cursor: pointer;
  padding: 0.3rem;
}

.error-msg {
  background: #fee2e2;
  color: #991b1b;
  padding: 0.8rem;
  border-radius: 10px;
  font-size: 0.85rem;
  font-weight: 600;
  margin-bottom: 1rem;
  border-left: 4px solid #ef4444;
}

.btn-login {
  width: 100%;
  padding: 1rem;
  background: linear-gradient(135deg, #6366f1, #4f46e5);
  color: white;
  border: none;
  border-radius: 12px;
  font-family: inherit;
  font-size: 1rem;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.2s;
  margin-top: 0.5rem;
}

.btn-login:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(99, 102, 241, 0.4);
}

.btn-login:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.login-info {
  margin-top: 1.5rem;
  padding: 0.8rem;
  background: #f8fafc;
  border-radius: 10px;
  text-align: center;
  font-size: 0.78rem;
  color: var(--gray);
  line-height: 1.6;
}

.login-info code {
  background: #eef2ff;
  color: #4f46e5;
  padding: 2px 6px;
  border-radius: 4px;
  font-weight: 700;
}
</style>