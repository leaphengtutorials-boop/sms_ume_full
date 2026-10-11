<template>
  <aside class="sidebar" id="sidebar">
    <!-- LOGO -->
    <div class="logo">
      <div class="logo-icon">📚</div>
      <div class="logo-text">
        <h2>គ្រប់គ្រងសិស្ស</h2>
        <small>Student Management</small>
      </div>
    </div>

    <!-- USER INFO -->
    <div v-if="auth.user" class="user-info">
      <div class="user-avatar">
        {{ auth.user.role === 'admin' ? '👨‍💼' : '👨‍🏫' }}
      </div>
      <div class="user-details">
        <div class="user-name">{{ auth.user.full_name }}</div>
        <div class="user-role">{{ roleLabel }}</div>
      </div>
    </div>

    <!-- MENU -->
    <nav class="menu">
      <router-link
        v-for="r in menuRoutes"
        :key="r.name"
        :to="{ name: r.name }"
      >
        <span>{{ r.meta.icon }}</span> {{ r.meta.title }}
      </router-link>
    </nav>

    <!-- LOGOUT -->
    <div class="logout-section">
      <button v-if="auth.user" class="btn-logout" @click="handleLogout">
        <span>🚪</span> ចាកចេញ
      </button>
    </div>
  </aside>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useToastStore } from '@/stores/toast'

const router = useRouter()
const auth = useAuthStore()
const toast = useToastStore()

const menuRoutes = computed(() =>
  router.options.routes.filter(r => r.meta?.title && !r.meta.public)
)

const roleLabel = computed(() => {
  const map = {
    admin: 'អ្នកគ្រប់គ្រង',
    teacher: 'គ្រូបង្រៀន',
  }
  return map[auth.user?.role] || auth.user?.role || ''
})

function handleLogout() {
  if (!confirm('តើអ្នកចង់ចាកចេញមែនទេ?')) return
  auth.logout()
  toast.show('✅ ចាកចេញជោគជ័យ', 'success')
  router.push('/login')   // ✅ ត្រឡប់ទៅ Login
}
</script>

<style scoped>
.user-info {
  display: flex;
  align-items: center;
  gap: 0.8rem;
  padding: 1rem 1.2rem;
  background: rgba(255, 255, 255, 0.04);
  border-top: 1px solid rgba(255, 255, 255, 0.08);
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
}

.user-avatar {
  font-size: 1.4rem;
  width: 42px;
  height: 42px;
  background: linear-gradient(135deg, #6366f1, #8b5cf6);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.user-details { flex: 1; min-width: 0; }

.user-name {
  font-size: 0.85rem;
  font-weight: 700;
  color: white;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.user-role {
  font-size: 0.7rem;
  color: rgba(255, 255, 255, 0.5);
  margin-top: 2px;
}

.logout-section {
  padding: 0.8rem 0.75rem;
  border-top: 1px solid rgba(255, 255, 255, 0.08);
}

.btn-logout {
  width: 100%;
  padding: 0.75rem 1rem;
  background: rgba(239, 68, 68, 0.12);
  color: #fca5a5;
  border: 1.5px solid rgba(239, 68, 68, 0.25);
  border-radius: 10px;
  font-family: inherit;
  font-size: 0.9rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
}

.btn-logout:hover {
  background: #ef4444;
  color: white;
  border-color: #ef4444;
  transform: translateY(-1px);
}

.menu {
  flex: 1;
  padding: 1rem 0.75rem;
  overflow-y: auto;
}

.menu::-webkit-scrollbar { width: 4px; }
.menu::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.15);
  border-radius: 2px;
}
</style>