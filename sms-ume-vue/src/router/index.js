import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const routes = [
  {
    path: '/login',
    name: 'login',
    component: () => import('@/views/LoginView.vue'),
    meta: { title: 'ចូលប្រើ', public: true }
  },
  {
    path: '/',
    name: 'dashboard',
    component: () => import('@/views/DashboardView.vue'),
    meta: { title: 'ផ្ទាំងគ្រប់គ្រង', icon: '📊', requiresAuth: true }
  },
  {
    path: '/subjects',
    name: 'subjects',
    component: () => import('@/views/SubjectsView.vue'),
    meta: { title: 'មុខវិជ្ជា', icon: '📚', requiresAuth: true }
  },
  {
    path: '/students',
    name: 'students',
    component: () => import('@/views/StudentsView.vue'),
    meta: { title: 'សិស្ស', icon: '👥', requiresAuth: true }
  },
  {
    path: '/enrollment',
    name: 'enrollment',
    component: () => import('@/views/EnrollmentView.vue'),
    meta: { title: 'ចុះឈ្មោះចូលរៀន', icon: '📝', requiresAuth: true }
  },
  {
    path: '/attendance',
    name: 'attendance',
    component: () => import('@/views/AttendanceView.vue'),
    meta: { title: 'វត្តមាន', icon: '✅', requiresAuth: true }
  },
  {
    path: '/homework',
    name: 'homework',
    component: () => import('@/views/HomeworkView.vue'),
    meta: { title: 'កិច្ចការ', icon: '📋', requiresAuth: true }
  },
  {
    path: '/scores-midterm',
    name: 'midterm',
    component: () => import('@/views/ScoresMidtermView.vue'),
    meta: { title: 'ពិន្ទុ Midterm', icon: '📝', requiresAuth: true }
  },
  {
    path: '/scores-final',
    name: 'final',
    component: () => import('@/views/ScoresFinalView.vue'),
    meta: { title: 'ពិន្ទុ Final', icon: '🎓', requiresAuth: true }
  },
  {
    path: '/reports',
    name: 'reports',
    component: () => import('@/views/ReportsView.vue'),
    meta: { title: 'លទ្ធផល', icon: '📈', requiresAuth: true }
  },
  {
    path: '/completed',
    name: 'completed',
    component: () => import('@/views/CompletedView.vue'),
    meta: { title: 'សិស្សបញ្ចប់', icon: '🎓', requiresAuth: true }
  },
  {
    path: '/settings',
    name: 'settings',
    component: () => import('@/views/SettingsView.vue'),
    meta: { title: 'ការកំណត់', icon: '⚙️', requiresAuth: true }
  },
  { path: '/:pathMatch(.*)*', redirect: '/' }
]

const router = createRouter({
  history: createWebHistory('/sms_ume/'),
  routes,
  scrollBehavior() {
    return { top: 0 }
  }
})

// ============================================================
// ✅ GUARD — ប្រើ sessionStorage ជំនួស Query Param
// ============================================================
router.beforeEach((to, from, next) => {
  const auth = useAuthStore()

  document.title = `${to.meta.title || ''} — SMS UME`

  // ============================================================
  // ១. Route Public (Login)
  // ============================================================
  if (to.meta.public) {
    // បើ Login រួច → Redirect ទៅ Dashboard
    if (auth.isLoggedIn && to.name === 'login') {
      return next('/')
    }
    return next()
  }

  // ============================================================
  // ២. បើមិនទាន់ Login → Redirect ទៅ Login
  //    ✅ ចងចាំ URL ដើមក្នុង sessionStorage (មិនបង្ហាញក្នុង URL)
  // ============================================================
  if (!auth.isLoggedIn) {
    // ✅ ចងចាំ URL ដើមក្នុង sessionStorage
    if (to.fullPath !== '/login') {
      sessionStorage.setItem('redirectAfterLogin', to.fullPath)
    }

    // ✅ Redirect ទៅ Login ដោយគ្មាន Query Param
    return next({ name: 'login' })
  }

  // ✅ អនុញ្ញាត
  next()
})

export default router