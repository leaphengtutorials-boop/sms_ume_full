<template>
  <!-- Login Page — គ្មាន Sidebar -->
  <template v-if="isLoginPage">
    <router-view />
  </template>

  <!-- App Pages — មាន Sidebar -->
  <template v-else>
    <Sidebar />
    <main class="main">
      <button class="menu-toggle" @click="toggleSidebar">☰</button>

      <router-view v-slot="{ Component }">
        <transition name="fade" mode="out-in">
          <component :is="Component" />
        </transition>
      </router-view>
    </main>
  </template>
</template>

<script setup>
import { computed, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import Sidebar from '@/components/Sidebar.vue'
import { useAppStore } from '@/stores/app'
import { useAuthStore } from '@/stores/auth'

const route = useRoute()
const app = useAppStore()
const auth = useAuthStore()

// ✅ Login Page?
const isLoginPage = computed(() => route.name === 'login')

function toggleSidebar() {
  document.getElementById('sidebar')?.classList.toggle('open')
}

// ✅ Load Data — តែបើ Login រួច
onMounted(() => {
  if (auth.isLoggedIn && !isLoginPage.value) {
    app.loadAll()
  }
})

// ✅ Watch — ពេល Login ជោគជ័យ → Load Data
watch(() => auth.isLoggedIn, (newVal) => {
  if (newVal) app.loadAll()
})
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>