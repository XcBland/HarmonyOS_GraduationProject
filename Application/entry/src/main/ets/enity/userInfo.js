/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2020-2020. All rights reserved.
 * Generated by the CloudDB ObjectType compiler. DO NOT EDIT!
 */

class userInfo_01 {
    constructor() {
        this.id = undefined;
        this.displayName = undefined;
        this.email = undefined;
        this.phoneNum = undefined;
        this.photoUrl = undefined;
        this.birthday = undefined;
        this.gender = "0";
        this.signature = undefined;
    }

    setId(id) {
        this.id = id;
    }

    getId() {
        return this.id;
    }

    setDisplayName(displayName) {
        this.displayName = displayName;
    }

    getDisplayName() {
        return this.displayName;
    }

    setEmail(email) {
        this.email = email;
    }

    getEmail() {
        return this.email;
    }

    setPhoneNum(phoneNum) {
        this.phoneNum = phoneNum;
    }

    getPhoneNum() {
        return this.phoneNum;
    }

    setPhotoUrl(photoUrl) {
        this.photoUrl = photoUrl;
    }

    getPhotoUrl() {
        return this.photoUrl;
    }

    setBirthday(birthday) {
        this.birthday = birthday;
    }

    getBirthday() {
        return this.birthday;
    }

    setGender(gender) {
        this.gender = gender;
    }

    getGender() {
        return this.gender;
    }

    setSignature(signature) {
        this.signature = signature;
    }

    getSignature() {
        return this.signature;
    }
}

userInfo_01.className = 'userInfo_01';

export {userInfo_01}