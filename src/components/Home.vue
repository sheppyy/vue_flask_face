<template>
  <el-container>
    <el-header>
      <div class="btns">
        <div v-if="isLogin === false">
          <el-button type="primary" size="mini" @click="login">登录</el-button>
          <el-button type="primary" size="mini" @click="register">注册</el-button>
        </div>
        <el-dropdown @command="handleCommand" v-else>
          <el-avatar icon="el-icon-user-solid"></el-avatar>
          <el-dropdown-menu slot="dropdown">
            <el-dropdown-item icon="el-icon-user" command="mine">个人中心</el-dropdown-item>
            <el-dropdown-item icon="el-icon-circle-close" command="logout">退出登录</el-dropdown-item>
          </el-dropdown-menu>
        </el-dropdown>
      </div>
    </el-header>
    <el-main>
      <router-view></router-view>
    </el-main>

    <!-- 登录Dialog -->
    <el-dialog title="登录" :visible.sync="loginDialogVisible" width="50%" @close="loginDialogClosed">
      <!-- 表单 -->
      <el-form :model="loginForm" :rules="loginFormRules" ref="loginFormRef">
        <el-form-item prop="username">
          <el-input v-model="loginForm.username" placeholder="用户名"></el-input>
        </el-form-item>
        <el-form-item prop="password">
          <el-input type="password" v-model="loginForm.password" placeholder="密码"></el-input>
        </el-form-item>
        <el-form-item>
          <el-checkbox v-model="checked">记住我</el-checkbox>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="loginDialogVisible = false" size="mini">取 消</el-button>
        <el-button type="primary" @click="confirmLogin" size="mini">登 录</el-button>
      </span>
    </el-dialog>

    <!-- 注册Dialog -->
    <el-dialog
      title="注册"
      :visible.sync="registerDialogVisible"
      width="50%"
      @close="registerDialogClosed"
    >
      <!-- 表单 -->
      <el-form :model="registerForm" :rules="registerFormRules" ref="registerFormRef">
        <el-form-item prop="username">
          <el-input v-model="registerForm.username" placeholder="用户名"></el-input>
        </el-form-item>
        <el-form-item prop="email">
          <el-input v-model="registerForm.email" placeholder="邮箱"></el-input>
        </el-form-item>
        <el-form-item prop="password">
          <el-input type="password" v-model="registerForm.password" placeholder="密码"></el-input>
        </el-form-item>
        <el-form-item prop="rePassword">
          <el-input type="password" v-model="registerForm.rePassword" placeholder="确认密码"></el-input>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="registerDialogVisible = false" size="mini">取 消</el-button>
        <el-button type="primary" @click="confirmRegister" size="mini">注 册</el-button>
      </span>
    </el-dialog>
  </el-container>
</template>
<script>
export default {
  inject: ['reload'],
  data() {
    return {
      loginDialogVisible: false, // 显示或隐藏登录对话框
      // 登录表单对象
      loginForm: {
        username: "ydc",
        password: "ydc"
      },
      // 登录表单验证对象
      loginFormRules: {
        username: [
          { required: true, message: "请输入用户名", trigger: "blur" },
          { min: 3, max: 15, message: "用户名长度为3-15", trigger: "blur" }
        ],
        password: [{ required: true, message: "请输入密码", trigger: "blur" }]
      },

      // 记住账号
      checked: false,
      registerForm: {
        username: "ydc",
        password: "ydc",
        email: "ydc@qq.com",
        rePassword: "ydc"
      },
      // 注册表单验证对象
      registerFormRules: {
        username: [
          { required: true, message: "请输入用户名", trigger: "blur" }
        ],
        email: [{ required: true, message: "请输入邮箱", trigger: "blur" }],
        password: [{ required: true, message: "请输入密码", trigger: "blur" }],
        rePassword: [
          { required: true, message: "请输入确认密码", trigger: "blur" },
          {
            validator: (rule, value, callback) => {
              if (value !== this.registerForm.password) {
                callback(new Error("两次输入密码不一致"));
              } else {
                callback();
              }
            },
            trigger: "blur"
          }
        ]
      },
      // 注册显示/隐藏
      registerDialogVisible: false,
      isLogin: false
    };
  },
  created() {
    this.checkedLogin();
  },
  methods: {
    // 点击登录按钮
    login() {
      this.loginDialogVisible = true;
    },
    // 登录对话框关闭触发
    loginDialogClosed() {
      this.$refs.loginFormRef.resetFields();
    },
    // 确定登录按钮
    async confirmLogin() {
      // 验证账号信息
      const username = this.loginForm.username;
      const password = this.loginForm.password;
      const res = await this.$http.post("login", {
        params: { name: username, pwd: password }
      });

      window.sessionStorage.setItem("token", res.data.token);

      // 保存账号信息
      console.log(this.checked);

      this.loginDialogVisible = false;
      this.reload()
      this.$router.push('/main')
    },
    // 注册按钮
    register() {
      this.registerDialogVisible = true;
    },
    // 注册对话框关闭触发
    registerDialogClosed() {
      this.$refs.registerFormRef.resetFields();
    },
    // 确定注册按钮
    async confirmRegister() {
      const username = this.registerForm.username;
      const password = this.registerForm.password;
      const email = this.registerForm.email;

      const res = await this.$http.post("register", {
        params: { name: username, pwd: password, email: email }
      });

      if (res.data.status !== 201) {
        this.registerDialogVisible = false;
        return this.$message.error(res.data.msg);
      }

      this.registerDialogVisible = false;
      this.$message.success("注册成功");

      this.loginForm.username = username
      this.loginForm.password = password
      this.loginDialogVisible = true
    },
    // 检查是否已经登录
    checkedLogin() {
      const token = window.sessionStorage.getItem("token");
      if (token === null) return;

      this.isLogin = true;
    },
    // 推出登录
    handleCommand(command) {
      if (command === "logout") {
        console.log('logout')
        window.sessionStorage.removeItem("token");
        this.$router.push('/')
        this.reload()
      }
    }
  }
};
</script>
<style lang="less" scoped>
.el-header {
  display: flex;
  align-items: center;
  height: 28px !important;
  .btns {
    position: absolute;
    right: 30px;
  }
}
.el-main {
  margin-top: 10px;
}

.el-container {
  height: 100%;
}
</style>