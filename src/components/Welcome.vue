<template>
  <div>
    <el-carousel :interval="4000" type="card" height="200px">
      <el-carousel-item class="e-item" v-for="item in 6" :key="item">
        <h3>阿里云服务器 新年大回馈</h3>
      </el-carousel-item>
    </el-carousel>
    <el-divider content-position="left">Vue - Flask</el-divider>
    <el-button type="primary" @click="toManage">进入后台</el-button>
  </div>
</template>
<script>
export default {
  data() {
    return {};
  },
  created() {},
  methods: {
    toManage(){
      const token = window.sessionStorage.getItem('token')
      if(token === null){
        return this.$message.error('请先登录');
      }

      this.$router.push('/main')
    }
  }
};
</script>
<style lang="less" scoped>
h3 {
  margin: 0;
  padding: 0;
}

.el-carousel__item {
  background-image: url("../assets/img/bg1.png");
  h3 {
    position: absolute;
    bottom: 5px;
    left: 5px;
    color: black;
  }
}
.el-card {
  height: 200px;
}
.el-button{
  display: block;
  margin: 50px auto;
}
</style>