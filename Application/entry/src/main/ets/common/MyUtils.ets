class MyUtils {
  // 这是一个日期转换函数（将长整形的时间戳--> 年-月-日 时:分:秒）
  transDateTime(timestamp: number): string {
    const date = new Date(timestamp);
    const year = date.getFullYear();
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const day = date.getDate().toString().padStart(2, '0');
    const hours = date.getHours().toString().padStart(2, '0');
    const minutes = date.getMinutes().toString().padStart(2, '0');
    const seconds = date.getSeconds().toString().padStart(2, '0');
    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
  }

  isValidDateTime(dateTimeString: string): boolean {
    // Define the date-time format we expect (e.g., "YYYY-MM-DD HH:mm:ss")
    const dateTimeFormat = /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/;

    // Check if the dateTimeString matches the format
    if (!dateTimeFormat.test(dateTimeString)) {
      return false;
    }

    // Try to create a Date object from the string
    const date = new Date(dateTimeString.replace(' ', 'T'));

    // Check if the date is valid
    if (isNaN(date.getTime())) {
      return false;
    }

    // Extract the individual components from the string
    const dateArray= dateTimeString.split(' ');
    const datePart = dateArray[0];
    const timePart = dateArray[1];
    //const [year, month, day] = datePart.split('-').map(Number);
    const timeArray1 = datePart.split('-');
    const year = Number(timeArray1[0]);
    const month = Number(timeArray1[1]);
    const day = Number(timeArray1[2]);

    // const [hour, minute, second] = timePart.split(':').map(Number);
    const  timeArray2 =  timePart.split(':');
    const hour = Number(timeArray2[0]);
    const minute = Number(timeArray2[1]);
    const second = Number(timeArray2[2])

    // Check if the components match the created date object
    if (date.getFullYear() !== year ||
      date.getMonth() + 1 !== month ||
      date.getDate() !== day ||
      date.getHours() !== hour ||
      date.getMinutes() !== minute ||
      date.getSeconds() !== second) {
      return false;
    }

    return true;
  }

  /**
   * 判断某个对象是否为空
   *
   * @param {object} obj
   * @return {boolean} true(empty)
   */
  isEmpty(obj: object | string): boolean {
    return obj === undefined || obj === null || obj === '';
  }



}
let myUtils = new MyUtils();

export { myUtils }