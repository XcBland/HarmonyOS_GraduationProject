
import dayjs from '@hview/dayjs'

export  class AgUser {
  uid: string;  // 用户id
  photoUrl: string; // 用户头像
  phone: string;  // 用户手机号
  email: string;  // 用户邮箱
  password: string;  // 用户密码
  displayName: string;  // 用户昵称
  registerDate: string;  // 用户注册时间
  lastLogin: string;  // 用户最后登录时间

  constructor(uid: string = "", photoUrl: string = "", phone: string = "", email: string = "", password: string = "", displayName: string = "",
    registerDate: string = "", lastLogin: string = "") {
    this.uid = uid;
    this.photoUrl = photoUrl;
    this.phone = phone;
    this.email = email;
    this.password = password;
    this.displayName = displayName;
    this.registerDate = dayjs(registerDate).format('YYYY-MM-DD HH:mm:ss');
    this.lastLogin =dayjs(lastLogin).format('YYYY-MM-DD HH:mm:ss');
  }

  getUid(): string {
    return this.uid;
  }

  getPhone(): string {
    return this.phone;
  }
  getEmail(): string {
    return this.email;
  }

  getPassword(): string {
    return this.password;
  }

  getDisplayName(): string {
    return this.displayName;
  }

  getPhotoUrl(): string {
    return this.photoUrl;
  }

  getRegisterDate(): string {
    return this.registerDate;
  }

  getLastLogin(): string {
    return this.lastLogin;
  }
}


