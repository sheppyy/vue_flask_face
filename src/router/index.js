import Vue from 'vue'
import Router from 'vue-router'
import Main from '@/components/Main'
import Home from '@/components/Home'
import Welcome from '@/components/Welcome'

// 样式
import '../assets/css/globle.css'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Home',
      component: Home,
      redirect: '/welcome',
      children: [
        {path: '/welcome', name: 'Welcome', component: Welcome},
        {path: '/main', name: 'Main', component: Main}
      ]
    },
  ]
})
