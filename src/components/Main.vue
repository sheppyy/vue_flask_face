<template>
  <el-tabs v-model="activeName" @tab-click="handleClick" tab-position="left">
    <el-tab-pane label="用户管理" name="first">
      <!-- 面包屑 -->
      <el-breadcrumb separator-class="el-icon-arrow-right">
        <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
        <el-breadcrumb-item>用户管理</el-breadcrumb-item>
      </el-breadcrumb>

      <el-row>
        <el-col :span="5">
          <!-- 添加用户按钮 -->
          <el-button type="primary" @click="add">添加用户</el-button>
        </el-col>
        <el-col :span="5">
          <!-- 搜索框 -->
          <el-input placeholder="请输入内容" v-model="queryInfo.query" clearable @clear="getCustomers">
            <el-button slot="append" icon="el-icon-search" @click="getCustomers"></el-button>
          </el-input>
        </el-col>
      </el-row>

      <!-- 表单 -->
      <el-table :data="customersTable" style="width: 100%" border stripe class="tableData">
        <el-table-column type="index"></el-table-column>
        <el-table-column prop="name" label="姓名" width="180" sortable></el-table-column>
        <el-table-column prop="address" label="地址" sortable></el-table-column>
        <el-table-column label="操作" width="130px">
          <template slot-scope="scope">
            <el-button
              type="primary"
              size="mini"
              icon="el-icon-edit"
              @click="editById(scope.row.id)"
            ></el-button>
            <el-button
              type="danger"
              size="mini"
              icon="el-icon-delete"
              @click="removeById(scope.row.id)"
            ></el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-pagination
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        :current-page="queryInfo.currentPage"
        :page-sizes="[5, 6, 7, 8]"
        :page-size="queryInfo.pageSize"
        layout="total, sizes, prev, pager, next, jumper"
        :total="total"
      ></el-pagination>
    </el-tab-pane>

    <!-- 添加用户对话框 -->
    <el-dialog title="添加用户" :visible.sync="addDialogVisible" width="50%" @close="addDialogClosed">
      <!-- 添加用户表单 -->
      <el-form :model="addForm" :rules="addFormRules" ref="addFormRef" label-width="100px">
        <el-form-item label="用户名称" prop="name">
          <el-input v-model="addForm.name"></el-input>
        </el-form-item>
        <el-form-item label="地址" prop="address">
          <el-input v-model="addForm.address"></el-input>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="editDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="addCustomer">确 定</el-button>
      </span>
    </el-dialog>

    <!-- 修改用户对话框 -->
    <el-dialog title="编辑用户" :visible.sync="editDialogVisible" width="50%" @close="editDialogClosed">
      <!-- 修改用户表单 -->
      <el-form :model="editForm" :rules="editFormRules" ref="editFormRef" label-width="100px">
        <el-form-item label="用户名称">
          <el-input v-model="editForm.name" disabled></el-input>
        </el-form-item>
        <el-form-item label="地址" prop="address">
          <el-input v-model="editForm.address"></el-input>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="editDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="editCustomer">确 定</el-button>
      </span>
    </el-dialog>
  </el-tabs>
</template>
<script>
export default {
  data() {
    return {
      // 默认激活的tab
      activeName: "first",
      // 用户数据
      customersTable: [],
      // 查询对象
      queryInfo: {
        query: "",
        pageSize: 5,
        currentPage: 1
      },
      total: 0,
      // 控制添加用户对话框显示/隐藏
      addDialogVisible: false,
      // 添加用户对话框表单对象
      addForm: {
        name: "",
        address: ""
      },
      // 添加表单对象验证对象
      addFormRules: {
        name: [{ required: true, message: "请输入用户名字", trigger: "blur" }],
        address: [
          { required: true, message: "请输入用户地址", trigger: "blur" }
        ]
      },
      //控制编辑用户对话框显示/隐藏
      editDialogVisible: false,
      // 编辑对话框表单对象
      editForm: {
        name: "",
        address: ""
      },
      // 编辑表单验证对象
      editFormRules: {
        address: [
          { required: true, message: "请输入用户地址", trigger: "blur" }
        ]
      },
      // 保存老的数据 用于判断是否发起请求修改
      oldAddress: ""
    };
  },
  created() {
    this.getCustomers();
  },
  mounted() {},
  methods: {
    // 标签被点击触发
    handleClick(tab, event) {
      console.log(tab);
    },
    // 页大小改变触发
    handleSizeChange(newSize) {
      this.queryInfo.pageSize = newSize;
      this.getCustomers();
    },
    // 页码改变触发
    handleCurrentChange(newPage) {
      this.queryInfo.currentPage = newPage;
      this.getCustomers();
    },
    // 获取用户数据
    async getCustomers() {
      const { data: res } = await this.$http.get("customers/", {
        params: this.queryInfo
      });
      if (res.status !== 200) {
        return this.$message.error(res.msg);
      }

      this.customersTable = res.customers;
      this.total = res.total;
    },
    // 添加对话框关闭触发
    addDialogClosed() {
      this.$refs.addFormRef.resetFields();
    },
    // 确定添加按钮
    addCustomer() {
      this.$refs.addFormRef.validate(async valid => {
        if (!valid) return;

        // 需要加/
        const { data: res } = await this.$http.post("customers/", {
          name: this.addForm.name,
          address: this.addForm.address
        });
        if (res.status !== 201) {
          return this.$message.error(res.msg);
        }

        this.addDialogVisible = false;
        this.$message.success(res.msg);
        this.getCustomers();
      });
    },
    // 添加按钮
    add() {
      this.addDialogVisible = true;
    },
    // 删除按钮
    async removeById(id) {
      const confirmResult = await this.$confirm(
        "此操作将永久删除该商品, 是否继续?",
        "提示",
        {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning"
        }
      ).catch(err => err);

      if (confirmResult !== "confirm") {
        return this.$message.info("已取消删除");
      }

      const res = await this.$http.delete(`customers/?id=${id}`);
      if (res.status !== 204) {
        return this.$message.error("删除失败");
      }

      this.$message.success("删除成功");
      this.getCustomers();
    },
    // 编辑按钮
    async editById(id) {
      this.editDialogVisible = true;
      const res = await this.$http.get(`customers/search?id=${id}`);

      this.editForm.name = res.data.customer.name;
      this.editForm.address = res.data.customer.address;
      this.oldAddress = res.data.customer.address;
    },
    // 编辑对话框关闭触发
    editDialogClosed() {
      this.$refs.editFormRef.resetFields();
    },
    // 确定编辑对话框按钮
    editCustomer() {
      this.$refs.editFormRef.validate(async valid => {
        if (!valid) {
          this.editDialogVisible = false;
          return;
        }

        // 验证提供则发起请求
        if (this.oldAddress !== this.editForm.address) {
          // 信息发生了修改 则发起修改请求
          const res = await this.$http.put('customers/edit', this.editForm);

          if(res.status !== 200){
            this.editDialogVisible = false;
            return this.$message.error('编辑用户信息失败')
          }

          this.$message.success('编辑用户信息成功')
          this.getCustomers()
          this.editDialogVisible = false;
        }
      });
    },

  }
};
</script>
<style lang="less" scoped>
.tableData {
  margin: 20px 0;
}
.el-row {
  margin-top: 20px;
}
</style>