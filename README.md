# YPDelContacts
删除手机通讯录中的所有人(ios9以上)

# 基于#Contacts
这个是没有UI的, 需要自己写UI, 我自己的需求很简单, 只是为了删除本地通讯录的所有联系人.
需要注意的几点: 
- 使用```#import <Contacts/Contacts.h>```的时候, 需要先获取授权, 可以在```APPDelegate.h```中请求获取授权,
我是在```viewController```中请求的,还需要在```info.plist```配置```NSContactsUsageDescription```.
- key设置为```CNContactGivenNameKey和CNContactPhoneNumbersKey```, 可以取出所有有giveName和PhoneNumber
的联系人,在对```contactStore```进行遍历的时候, 每次删除都需要重新生成一个```CNSaveRequest```, 然后调用```deleteContact:```
每次调用之后,都要用```contactStore```调用```executeSaveRequest:error:```.

# 扩展
可以在此思路的基础上, 做对通讯录的改/查等操作.
