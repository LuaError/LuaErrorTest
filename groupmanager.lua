
local TIME_CHECK = 2
local SUDO = 206480168 -- put Your ID here! <===
local function index_function(user_id)
  for k,v in pairs(_config.admins) do
    if user_id == v[1] then
    	print(k)
      return k
    end
  end
  -- If not found
  return false
end
local function getindex(t,id) 
for i,v in pairs(t) do 
if v == id then 
return i 
end 
end 
return nil 
end 
local function already_sudo(user_id)
  for k,v in pairs(_config.sudo_users) do
    if user_id == v then
      return k
    end
  end
  -- If not found
  return false
end
local function reload_plugins( ) 
  plugins = {} 
  load_plugins() 
end
local function sudolist(msg)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
local sudo_users = _config.sudo_users
  if not lang then
 text = "📋*List of sudo users👤 :*\n"
   else
 text = "📋_لیست سودو های ربات👤 :_\n"
  end
for i=1,#sudo_users do
    text = text..i.." - "..sudo_users[i].."\n"
end
return text
end
local function adminlist(msg)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
local sudo_users = _config.sudo_users
  if not lang then
 text = '📋*List of bot admins👥 :*\n'
   else
 text = "📋_لیست ادمین های ربات👥 :_\n"
  end
		  	local compare = text
		  	local i = 1
		  	for v,user in pairs(_config.admins) do
			    text = text..i..'- '..(user[2] or '')..' ➣ ('..user[1]..')\n'
		  	i = i +1
		  	end
		  	if compare == text then
   if not lang then
		  		text = '❗️_No_ *admins* _available_❗️'
      else
		  		text = '❗️_ادمینی برای ربات تعیین نشده_❗️'
           end
		  	end
		  	return text
    end
	local function chat_list(msg)
	i = 1
	local data = load_data(_config.moderation.data)
    local groups = 'groups'
    if not data[tostring(groups)] then
        return 'No groups at the moment'
    end
    local message = '📜List of Groups📜:\n*Use #join (ID) to join*\n\n'
    for k,v in pairsByKeys(data[tostring(groups)]) do
		local group_id = v
		if data[tostring(group_id)] then
			settings = data[tostring(group_id)]['settings']
		end
        for m,n in pairsByKeys(settings) do
			if m == 'set_name' then
				name = n:gsub("", "")
				chat_name = name:gsub("‮", "")
				group_name_id = name .. '\n(ID: ' ..group_id.. ')\n\n'
				if name:match("[\216-\219][\128-\191]") then
					group_info = i..' - \n'..group_name_id
				else
					group_info = i..' - '..group_name_id
				end
				i = i + 1
			end
        end
		message = message..group_info
    end
	return message
end
local function modadd(msg)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
    -- superuser and admins only (because sudo are always has privilege)
    if not is_admin(msg) then
   if not lang then
        return '*Error❢*\n❗️_You are not bot admin_❗️'
else
     return '_اخطار❢_\n❗️شما مدیر ربات نمیباشید❗️'
    end
end
    local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)] then
if not lang then
   return '*Error❢*\n♻️_Group is already added_🛡'
else
return '_اخطار❢_\n♻️گروه در لیست گروه های مدیریتی ربات هم اکنون موجود است🛡'
  end
end
        -- create data array in moderation.json
      data[tostring(msg.to.id)] = {
              owners = {},
      mods ={},
      banned ={},
      is_silent_users ={},
      filterlist ={},
      settings = {
          set_name = msg.to.title,
          lock_link = 'yes',
          lock_tag = 'yes',
          lock_spam = 'yes',
          lock_webpage = 'no',
          lock_markdown = 'no',
          flood = 'yes',
          lock_bots = 'yes',
          lock_pin = 'no',
          welcome = 'no',
          },
   mutes = {
                  mute_fwd = 'no',
                  mute_audio = 'no',
                  mute_video = 'no',
                  mute_contact = 'no',
                  mute_text = 'no',
                  mute_photos = 'no',
                  mute_gif = 'no',
                  mute_loc = 'no',
                  mute_doc = 'no',
                  mute_sticker = 'no',
                  mute_voice = 'no',
                   mute_all = 'no',
				   mute_keyboard = 'no'
          }
      }
  save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = msg.to.id
      save_data(_config.moderation.data, data)
    if not lang then
  return '📜*Group has been added to database*💾'
else
  return '📜گروه با موفقیت به لیست گروه های مدیریتی ربات افزوده شد💾'
end
end
local function modrem(msg)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
    -- superuser and admins only (because sudo are always has privilege)
      if not is_admin(msg) then
     if not lang then
        return '*Error❢*\n❗️_You are not bot admin_❗️'
   else
        return '_اخطار❢_\n❗️شما مدیر ربات نمیباشید❗️'
    end
   end
    local data = load_data(_config.moderation.data)
    local receiver = msg.to.id
  if not data[tostring(msg.to.id)] then
  if not lang then
    return '⚠️_Group is not added_⚠️'
else
    return '⚠️گروه به لیست گروه های مدیریتی ربات اضافه نشده است⚠️'
   end
  end

  data[tostring(msg.to.id)] = nil
  save_data(_config.moderation.data, data)
     local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end data[tostring(groups)][tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
 if not lang then
  return '*Done!*\n📜*Group has been removed*🗑'
 else
  return '_انجام شد!_\n📜گروه با موفیت از لیست گروه های مدیریتی ربات حذف شد🗑'
end
end

local function filter_word(msg, word)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
local data = load_data(_config.moderation.data)
  if not data[tostring(msg.to.id)]['filterlist'] then
    data[tostring(msg.to.id)]['filterlist'] = {}
    save_data(_config.moderation.data, data)
    end
if data[tostring(msg.to.id)]['filterlist'][(word)] then
   if not lang then
         return "🔏_Word_ *"..word.."* _is already filtered_📋"
            else
         return "🔏_کلمه_ *"..word.."* _از قبل فیلتر بود_📋"
    end
end
   data[tostring(msg.to.id)]['filterlist'][(word)] = true
     save_data(_config.moderation.data, data)
   if not lang then
         return "🔏_Word_ *"..word.."* _added to filtered words list_📋"
            else
         return "🔏_کلمه_ *"..word.."* _به لیست کلمات فیلتر شده اضافه شد_📋"
    end
end

local function unfilter_word(msg, word)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 local data = load_data(_config.moderation.data)
  if not data[tostring(msg.to.id)]['filterlist'] then
    data[tostring(msg.to.id)]['filterlist'] = {}
    save_data(_config.moderation.data, data)
    end
      if data[tostring(msg.to.id)]['filterlist'][word] then
      data[tostring(msg.to.id)]['filterlist'][(word)] = nil
       save_data(_config.moderation.data, data)
       if not lang then
         return "✒️_Word_ *"..word.."* _removed from filtered words list_📋"
       elseif lang then
         return "✒️_کلمه_ *"..word.."* _از لیست کلمات فیلتر شده حذف شد_📋"
     end
      else
       if not lang then
         return "✒️_Word_ *"..word.."* _is not filtered_📋"
       elseif lang then
         return "✒️_کلمه_ *"..word.."* _از قبل فیلتر نبود_📋"
      end
   end
end

local function modlist(msg)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.chat_id_)] then
  if not lang then
    return "⚠️_Group is not added_⚠️"
 else
    return "⚠️گروه به لیست گروه های مدیریتی ربات اضافه نشده است⚠️"
  end
 end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['mods']) == nil then --fix way
  if not lang then
    return "👥_No_ *moderator* _in this group_👥"
else
   return "👥در حال حاضر هیچ مدیری برای گروه انتخاب نشده است👥"
  end
end
if not lang then
   message = '📋*List of moderators👥 :*\n'
else
   message = '📋*لیست مدیران گروه👥 :*\n'
end
  for k,v in pairs(data[tostring(msg.to.id)]['mods'])
do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

local function ownerlist(msg)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.to.id)] then
if not lang then
    return "⚠️_Group is not added_⚠️"
else
return "⚠️گروه به لیست گروه های مدیریتی ربات اضافه نشده است⚠️"
  end
end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['owners']) == nil then --fix way
 if not lang then
    return "👤_No_ *owner* _in this group_👤"
else
    return "👤در حال حاضر هیچ مالکی برای گروه انتخاب نشده است👤"
  end
end
if not lang then
   message = '📋*List of moderators👤 :*\n'
else
   message = '📋*لیست مالکین گروه👤 :*\n'
end
  for k,v in pairs(data[tostring(msg.to.id)]['owners']) do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

local function action_by_reply(arg, data)
  local cmd = arg.cmd
if not tonumber(data.sender_user_id_) then return false end
    if data.sender_user_id_ then
    if cmd == "adminprom" then
local function adminprom_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if is_admin1(tonumber(data.id_)) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_User_ "..user_name.." *"..data.id_.."* _is already an_ *admin*👥", 0, "md")
  else
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_کاربر_ "..user_name.." *"..data.id_.."* _از قبل ادمین ربات بود_👥", 0, "md")
      end
   end
	    table.insert(_config.admins, {tonumber(data.id_), user_name})
		save_config()
     if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_User_ "..user_name.." *"..data.id_.."* _has been promoted as_ *admin*👥", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_کاربر_ "..user_name.." *"..data.id_.."* _به مقام ادمین ربات منتصب شد_👥", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, adminprom_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "admindem" then
local function admindem_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
	local nameid = index_function(tonumber(data.id_))
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if not is_admin1(data.id_) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_User_ "..user_name.." *"..data.id_.."* _is not a_ *admin*❌👥", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_کاربر_ "..user_name.." *"..data.id_.."* _از قبل ادمین ربات نبود_❌👥", 0, "md")
      end
   end
		table.remove(_config.admins, nameid)
		save_config()
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_User_ "..user_name.." *"..data.id_.."* _has been demoted from_ *admin*❌👥", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_کاربر_ "..user_name.." *"..data.id_.."* _از مقام ادمین ربات برکنار شد_❌👥", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, admindem_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "visudo" then
local function visudo_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if already_sudo(tonumber(data.id_)) then
  if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_User_ "..user_name.." *"..data.id_.."* _is already a_ *sudoer*👤", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_کاربر_ "..user_name.." *"..data.id_.."* _از قبل سودو ربات بود_👤", 0, "md")
      end
   end
          table.insert(_config.sudo_users, tonumber(data.id_))
		save_config()
     reload_plugins(true)
  if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_User_ "..user_name.." *"..data.id_.."* _is now_ *sudoer*👤", 0, "md")
  else
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_کاربر_ "..user_name.." *"..data.id_.."* _به مقام سودو ربات منتصب شد_👤", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, visudo_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "desudo" then
local function desudo_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
     if not already_sudo(data.id_) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_User_ "..user_name.." *"..data.id_.."* _is not a_ *sudoer*❌👤", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_کاربر_ "..user_name.." *"..data.id_.."* _از قبل سودو ربات نبود_❌👤", 0, "md")
      end
   end
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(data.id_)))
		save_config()
     reload_plugins(true) 
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_User_ "..user_name.." *"..data.id_.."* _is no longer a_ *sudoer*❌👤", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_کاربر_ "..user_name.." *"..data.id_.."* _از مقام سودو ربات برکنار شد_❌👤", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, desudo_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
else
    if lang then
  return tdcli.sendMessage(data.chat_id_, "", 0, "_کاربر یافت نشد_", 0, "md")
   else
  return tdcli.sendMessage(data.chat_id_, "", 0, "*User Not Found*", 0, "md")
      end
   end
local hash = "gp_lang:"..data.chat_id_
local lang = redis:get(hash)
  local cmd = arg.cmd
if not tonumber(data.sender_user_id_) then return false end
if data.sender_user_id_ then
  if cmd == "ban" then
local function ban_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
   if is_mod1(arg.chat_id, data.id_) then
  if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\nYou can't*ban*\n`【✶Mods,✷Owners & ❈BotAdmins】`", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "_اخطار❢_\n_شما نمیتوانید افراد ذیل شده را بن کنید:_\n`【✶مدیران,✷اونر ها & ❈ادمین های ربات】`", 0, "md")
         end
     end
if administration[tostring(arg.chat_id)]['banned'][tostring(data.id_)] then
    if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\n`User is Already Banned`\n*User info:* \n_User name: _ "..user_name.."\n_User Id:_ *"..data.id_.."*", 0, "md")
   else
     return tdcli.sendMessage(arg.chat_id, "", 0, "_خطا❢_\n`کاربر از گروه محروم بود`\n `اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n _آیدی:_ *"..data.id_.."*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['banned'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   kick_user(data.id_, arg.chat_id)
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*Done!*\n`User Has been Baned`\n*User info:*\n_Username:_ "..user_name.."\n_User id :_ *"..data.id_.."*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_انجام شد!_ \n`کاربر از گروه محروم شد`\n `اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n_ایدی:_ *[ "..data.id_.." ]*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, ban_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
   if cmd == "unban" then
local function unban_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if not administration[tostring(arg.chat_id)]['banned'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\n`User is not Bannded`\n*User Info:*\n_User name:_ "..user_name.."\n_User Id:_ *"..data.id_.."*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_خطا❢_\n`کاربر از گروه محروم نبود`\n`اطلاعات کاربر:`\n_یوزنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['banned'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*Done!*\n`User has been Unbanned`\n*User Info:*\n_User name:_ "..user_name.."\n_User Id:_ *"..data.id_.."*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_انجام شد!_ \n`کاربرازمحرومیت گروه خارج شد`\n `اطلاعات کاربر:`\n _یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, unban_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
  if cmd == "silentuser" then
local function silent_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
   if is_mod1(arg.chat_id, data.id_) then
  if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\nYou can't *Silent*:\n`【✶Mods,✷Owners & ❈BotAdmins】`", 0, "md")
    else
  return tdcli.sendMessage(arg.chat_id, "", 0, "_اخطار❢_\n_شما نمیتوانید افراد ذیل شده را سایلنت کنید:_\n`【✶مدیران,✷اونر ها & ❈ادمین های ربات】`", 0, "md")
       end
     end
if administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id_)] then
    if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\n`User is Already Silent`\n*User info:* \n_User name: _ "..user_name.."\n_User Id:_ *"..data.id_.."*", 0, "md")
  else
     return tdcli.sendMessage(arg.chat_id, "", 0, "_خطا❢_\n`کاربراز قبل سایلنت بود`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n _آیدی:_ *"..data.id_.."*", 0, "md")
     end
   end
administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
  if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "*Done!*\n`User Added to Silent list`\n*User Info:*\n_User name:_ "..user_name.."\n_User Id:_ *"..data.id_.."*", 0, "md")
  else
     return tdcli.sendMessage(arg.chat_id, "", 0, "_انجام شد!_\n`کاربر توانایی چت کردن رو از دست داد`\n `اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n _آیدی:_ *"..data.id_.."*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, silent_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
  if cmd == "unsilentuser" then
local function unsilent_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if not administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\n `User is not Silent`\n*User Info:*\n_User name:_ "..user_name.."\n_User Id:_ *"..data.id_.."*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_خطا❢_\n`کاربر از قبل توانایی چت کردن رو داشت`\n `اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n _آیدی:_ *"..data.id_.."*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
    if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "*Done!*\n`User Removed frome Silent list`\n*User Info:*\n_User name:_ "..user_name.."\n_User Id:_ *"..data.id_.."*", 0, "md")
  else
     return tdcli.sendMessage(arg.chat_id, "", 0, "_انجام شد!_\n`کاربر توانایی چت کردن رو بدست اورد`\n `اطلاعات کاربر:`\n _یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, unsilent_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
  if cmd == "gban" then
local function gban_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
  if not administration['gban_users'] then
    administration['gban_users'] = {}
    save_data(_config.moderation.data, administration)
    end
   if is_admin1(data.id_) then
  if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\nYou can't *globally ban*\n `【✶Mods,✷Owners & ❈BotAdmins】`", 0, "md")
  else
  return tdcli.sendMessage(arg.chat_id, "", 0, "_اخطار❢_\n_شما نمیتوانید  افراد ذیل شده را ازتمام گروه های ربات محروم کنید_\n`【✶مدیران,✷اونر ها & ❈ادمین های ربات】`", 0, "md")
        end
     end
if is_gbanned(data.id_) then
   if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\n`User is Already globally bannded`\n*User info:*\n_User name: _ "..user_name.."\n_User Id:_ *"..data.id_.."*", 0, "md")
    else
     return tdcli.sendMessage(arg.chat_id, "", 0, "_خطا❢_\n`کاربر از گروه های برات محروم بود`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n _آیدی:_ *"..data.id_.."*", 0, "md")
      end
   end
  administration['gban_users'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   kick_user(data.id_, arg.chat_id)
     if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "*Done!*\n`User has been Globally Baned`\n*User Info:*\n_User name:_ "..user_name.."\n_User Id:_ *"..data.id_.."*", 0, "md")
   else
     return tdcli.sendMessage(arg.chat_id, "", 0, "_انجام شد!_\n`کاربرازتمام گروه های بات محروم شد`\n `اطلاعات کاربر:`\n _یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, gban_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
  if cmd == "ungban" then
local function ungban_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
  if not administration['gban_users'] then
    administration['gban_users'] = {}
    save_data(_config.moderation.data, administration)
    end
if not is_gbanned(data.id_) then
   if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\n`User is not globally banned`\n*User info:*\n_User name: _ "..user_name.."\n_User Id:_ *"..data.id_.."*", 0, "md")
   else
     return tdcli.sendMessage(arg.chat_id, "", 0, "_خطا❢_\n`کاربرازتمام گروه های ربات محروم نبود`\n`اطلاعات کاربر:`\n _یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
      end
   end
  administration['gban_users'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
    if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "*Done!*\n`User has been Globally unBaned`\n*User Info:*\n_User name:_ "..user_name.."\n_User Id:_ *"..data.id_.."*", 0, "md")
   else
     return tdcli.sendMessage(arg.chat_id, "", 0, "_انجام شد!_\n`کاربر از محرومیت گروه های ربات خارج شد`\n `اطلاعات کاربر:`\n _یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, ungban_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
  if cmd == "kick" then
   if is_mod1(data.chat_id_, data.sender_user_id_) then
   if not lang then
  return tdcli.sendMessage(data.chat_id_, "", 0, "*Error❢*\nYou can't *kick*\n`【✶Mods,✷Owners & ❈BotAdmins】`", 0, "md")
    elseif lang then
  return tdcli.sendMessage(data.chat_id_, "", 0, "_اخطار❢_\n_شما نمیتوانید افراد ذیل شده را اخراج کنید_\n`【✶مدیران,✷اونر ها & ❈ادمین های ربات】`", 0, "md")
   end
  else
     kick_user(data.sender_user_id_, data.chat_id_)
     end
  end
  if cmd == "delall" then
   if is_mod1(data.chat_id_, data.sender_user_id_) then
   if not lang then
  return tdcli.sendMessage(data.chat_id_, "", 0, "*Error❢*\nYou can't *delete chat*\n`【✶Mods,✷Owners & ❈BotAdmins】`", 0, "md")
   elseif lang then
  return tdcli.sendMessage(data.chat_id_, "", 0, "_اخطار❢_\n_شما نمیتوانید پیام افراد ذیل شده را پاک کنید_\n`【✶مدیران,✷اونر ها & ❈ادمین های ربات】`", 0, "md")
   end
  else
tdcli.deleteMessagesFromUser(data.chat_id_, data.sender_user_id_, dl_cb, nil)
   if not lang then
  return tdcli.sendMessage(data.chat_id_, "", 0, "*Done!*\n `All messages this User has been deleted` \n*User Info:*\n_User name:_ "..user_name.."\n_User Id:_ *"..data.sender_user_id_.."*", 0, "md")
      elseif lang then
  return tdcli.sendMessage(data.chat_id_, "", 0, "_انجام شد!_\n `تمام پیام های این کاربر پاک شد` \n_اطلاعات کاربر:_\n_آیدی:_ *"..data.sender_user_id_.."*", 0, "md")
       end
    end
  end
else
    if lang then
  return tdcli.sendMessage(data.chat_id_, "", 0, "_خطا❢_\n`کاربر در گروه وجود ندارد`", 0, "md")
   else
  return tdcli.sendMessage(data.chat_id_, "", 0, "Error❢*\n`User Not Found this group`", 0, "md")
      end
   end
local hash = "gp_lang:"..data.chat_id_
local lang = redis:get(hash)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
if not tonumber(data.sender_user_id_) then return false end
    if data.sender_user_id_ then
  if not administration[tostring(data.chat_id_)] then
  if not lang then
    return tdcli.sendMessage(data.chat_id_, "", 0, "⚠️_Group is not added_⚠️", 0, "md")
else
    return tdcli.sendMessage(data.chat_id_, "", 0, "_گروه به لیست گروه های مدیریتی ربات اضافه نشده است_", 0, "md")
     end
  end
if cmd == "setowner" then
local function owner_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\n`User is already a group owner`\n*userinfo:*\n_username:_ "..user_name.."\n_userid:_ *"..data.id_.."*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_اخطار❢_\n`کاربر از قبل صاحب گروه بود`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "*Done!*\n`User is now the group owner`\n*userinfo:*\n_username:_"..user_name.."\n_userid:_*"..data.id_.."*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "_انجام شد!_\n`کاربر به مقام صاحب گروه منتصب شد`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, owner_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "modset" then
local function promote_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\n`User is already a moderator`\n*userinfo:*\n_username:_ "..user_name.."\n_userid:_ *"..data.id_.."*", 0, "md")
else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_اخطار❢_\n`کاربر از قبل مدیر گروه بود`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*Done!*\n`User has been promoted`\n*userinfo:*\n_username:_"..user_name.."\n_userid:_*"..data.id_.."*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_انجام شد!_\n`کاربر به مقام مدیر گروه منتصب شد`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, promote_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
     if cmd == "remowner" then
local function rem_owner_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\n`User is not a group owner`\n*userinfo:*\n_username:_"..user_name.."\n_userid:_*"..data.id_.."*", 0, "md")
   else
return tdcli.sendMessage(arg.chat_id, "", 0, "_اخطار❢_\n`کاربر از قبل صاحب گروه نبود`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "*Done!*\n`User is no longer a group owner`\n*userinfo:*\n_username:_"..user_name.."\n_userid:_*"..data.id_.."*", 0, "md")
    else
return tdcli.sendMessage(arg.chat_id, "", 0, "_انجام شد!_\n`کاربراز مقام صاحب گروه برکنار شد`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, rem_owner_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "moddem" then
local function demote_cb(arg, data)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\n`User is not a moderator`\n*userinfo:*\n_username:_"..user_name.."\n_userid:_*"..data.id_.."*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_اخطار❢_\n`کاربر از قبل مدیر گروه نبود`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
   end
  end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*Done!*\n`User has been demoted`\n*userinfo:*\n_username:_"..user_name.."\n_userid:_*"..data.id_.."*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_انجام شد!_\n`کاربر از مقام مدیر گروه برکنار شد`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, demote_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "userid" then
local function id_cb(arg, data)
    return tdcli.sendMessage(arg.chat_id, "", 0, "*"..data.id_.."*", 0, "md")
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, id_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
else
    if lang then
  return tdcli.sendMessage(data.chat_id_, "", 0, "_کاربر یافت نشد_", 0, "md")
   else
  return tdcli.sendMessage(data.chat_id_, "", 0, "*User Not Found*", 0, "md")
      end
   end
end

local function action_by_username(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local cmd = arg.cmd
if not arg.username then return false end
    if data.id_ then
if data.type_.user_.username_ then
user_name = '@'..check_markdown(data.type_.user_.username_)
else
user_name = check_markdown(data.title_)
end
    if cmd == "adminprom" then
if is_admin1(tonumber(data.id_)) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_User_ "..user_name.." *"..data.id_.."* _is already an_ *admin*", 0, "md")
  else
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_کاربر_ "..user_name.." *"..data.id_.."* _از قبل ادمین ربات بود_", 0, "md")
      end
   end
	    table.insert(_config.admins, {tonumber(data.id_), user_name})
		save_config()
     if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_User_ "..user_name.." *"..data.id_.."* _has been promoted as_ *admin*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_کاربر_ "..user_name.." *"..data.id_.."* _به مقام ادمین ربات منتصب شد_", 0, "md")
   end
end
    if cmd == "admindem" then
	local nameid = index_function(tonumber(data.id_))
if not is_admin1(data.id_) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_User_ "..user_name.." *"..data.id_.."* _is not a_ *admin*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_کاربر_ "..user_name.." *"..data.id_.."* _از قبل ادمین ربات نبود_", 0, "md")
      end
   end
		table.remove(_config.admins, nameid)
		save_config()
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_User_ "..user_name.." *"..data.id_.."* _has been demoted from_ *admin*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_کاربر_ "..user_name.." *"..data.id_.."* _از مقام ادمین ربات برکنار شد_", 0, "md")
   end
end
    if cmd == "visudo" then
if already_sudo(tonumber(data.id_)) then
  if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_User_ "..user_name.." *"..data.id_.."* _is already a_ *sudoer*👤", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_کاربر_ "..user_name.." *"..data.id_.."* _از قبل سودو ربات بود_👤", 0, "md")
      end
   end
          table.insert(_config.sudo_users, tonumber(data.id_))
		save_config()
     reload_plugins(true)
  if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_User_ "..user_name.." *"..data.id_.."* _is now_ *sudoer*👤", 0, "md")
  else
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_کاربر_ "..user_name.." *"..data.id_.."* _به مقام سودو ربات منتصب شد_👤", 0, "md")
   end
end
    if cmd == "desudo" then
     if not already_sudo(data.id_) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_User_ "..user_name.." *"..data.id_.."* _is not a_ *sudoer*❌👤", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_کاربر_ "..user_name.." *"..data.id_.."* _از قبل سودو ربات نبود_❌👤", 0, "md")
      end
   end
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(data.id_)))
		save_config()
     reload_plugins(true) 
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_User_ "..user_name.." *"..data.id_.."* _is no longer a_ *sudoer*❌👤", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_کاربر_ "..user_name.." *"..data.id_.."* _از مقام سودو ربات برکنار شد_❌👤", 0, "md")
      end
   end
else
    if lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر یافت نشد_", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "*User Not Found*", 0, "md")
      end
   end
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
  local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
if not arg.username then return false end
    if data.id_ then
if data.type_.user_.username_ then
user_name = '@'..check_markdown(data.type_.user_.username_)
else
user_name = check_markdown(data.title_)
end
  if cmd == "ban" then
   if is_mod1(arg.chat_id, data.id_) then
  if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\nYou can't*ban*\n`【✶Mods,✷Owners & ❈BotAdmins】`", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "_اخطار❢_\n_شما نمیتوانید افراد ذیل شده رااز گروه بن کنید_\n`【✶مدیران,✷اونر ها & ❈ادمین های ربات】`", 0, "md")
         end
     end
if administration[tostring(arg.chat_id)]['banned'][tostring(data.id_)] then
    if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\n`User is Already Banned`\n*User info: *\n_User name:_ "..user_name.."\n_User id :_ *"..data.id_.."*", 0, "md")
   else
     return tdcli.sendMessage(arg.chat_id, "", 0, "_خطا❢_\n`کاربر از گروه محروم بود`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n _آیدی:_ *"..data.id_.."*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['banned'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   kick_user(data.id_, arg.chat_id)
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*Done!*\n`User Has been Baned`\n*User info:*\n_Username:_ "..user_name.."\n_User id :_ *"..data.id_.."*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_انجام شد!_ \n`کاربر از گروه محروم شد`\n `اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n_ایدی:_ *[ "..data.id_.." ]*", 0, "md")
   end
end
   if cmd == "unban" then
if not administration[tostring(arg.chat_id)]['banned'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\n`User is not Bannded`\n*User Info:*\n_User name:_ "..user_name.."\n_User Id:_ *"..data.id_.."*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_خطا❢_\n`کاربر از گروه محروم نبود`\n`اطلاعات کاربر:`\n_یوزنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['banned'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*Done!*\n`User has been Unbanned`\n*User Info:*\n_User name:_ "..user_name.."\n_User Id:_ *"..data.id_.."*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_انجام شد!_ \n`کاربرازمحرومیت گروه خارج شد`\n `اطلاعات کاربر:`\n _یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
   end
end
  if cmd == "silentuser" then
   if is_mod1(arg.chat_id, data.id_) then
  if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\nYou can't *Silent*:\n`【✶Mods,✷Owners & ❈BotAdmins】`", 0, "md")
    else
  return tdcli.sendMessage(arg.chat_id, "", 0, "_اخطار❢_\n_شما نمیتوانید افراد ذیل شده را سایلنت کنید:_\n`【✶مدیران,✷اونر ها & ❈ادمین های ربات】`", 0, "md")
       end
     end
if administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id_)] then
    if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\n`User is Already Silent`\n*User info:* \n_User name: _ "..user_name.."\n_User Id:_ *"..data.id_.."*", 0, "md")
  else
     return tdcli.sendMessage(arg.chat_id, "", 0, "_خطا❢_\n`کاربراز قبل سایلنت بود`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n _آیدی:_ *"..data.id_.."*", 0, "md")
     end
   end
administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
  if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "*Done!*\n`User Added to Silent list`\n*User Info:*\n_User name:_ "..user_name.."\n_User Id:_ *"..data.id_.."*", 0, "md")
  else
     return tdcli.sendMessage(arg.chat_id, "", 0, "_انجام شد!_\n`کاربر توانایی چت کردن رو از دست داد`\n `اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n _آیدی:_ *"..data.id_.."*", 0, "md")
   end
end
  if cmd == "unsilentuser" then
if not administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\n `User is not Silent`\n*User Info:*\n_User name:_ "..user_name.."\n_User Id:_ *"..data.id_.."*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_خطا❢_\n`کاربر از قبل توانایی چت کردن رو داشت`\n `اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n _آیدی:_ *"..data.id_.."*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['is_silent_users'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
    if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "*Done!*\n`User Removed frome Silent list`\n*User Info:*\n_User name:_ "..user_name.."\n_User Id:_ *"..data.id_.."*", 0, "md")
  else
     return tdcli.sendMessage(arg.chat_id, "", 0, "_انجام شد!_\n`کاربر توانایی چت کردن رو بدست اورد`\n `اطلاعات کاربر:`\n _یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
   end
end
  if cmd == "gban" then
  if not administration['gban_users'] then
    administration['gban_users'] = {}
    save_data(_config.moderation.data, administration)
    end
   if is_admin1(data.id_) then
  if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\nYou can't *globally ban*\n `【✶Mods,✷Owners & ❈BotAdmins】`", 0, "md")
  else
  return tdcli.sendMessage(arg.chat_id, "", 0, "_اخطار❢_\n_شما نمیتوانید  افراد ذیل شده را ازتمام گروه های ربات محروم کنید_\n`【✶مدیران,✷اونر ها & ❈ادمین های ربات】`", 0, "md")
        end
     end
if is_gbanned(data.id_) then
   if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\n`User is Already globally bannded`\n*User info:*\n_User name: _ "..user_name.."\n_User Id:_ *"..data.id_.."*", 0, "md")
    else
     return tdcli.sendMessage(arg.chat_id, "", 0, "_خطا❢_\n`کاربر از گروه های برات محروم بود`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n _آیدی:_ *"..data.id_.."*", 0, "md")
      end
   end
  administration['gban_users'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   kick_user(data.id_, arg.chat_id)
     if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "*Done!*\n`User has been Globally Baned`\n*User Info:*\n_User name:_ "..user_name.."\n_User Id:_ *"..data.id_.."*", 0, "md")
   else
     return tdcli.sendMessage(arg.chat_id, "", 0, "_انجام شد!_\n`کاربرازتمام گروه های بات محروم شد`\n `اطلاعات کاربر:`\n _یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
   end
end
  if cmd == "ungban" then
  if not administration['gban_users'] then
    administration['gban_users'] = {}
    save_data(_config.moderation.data, administration)
    end
if not is_gbanned(data.id_) then
     if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\n`User is not globally banned`\n*User info:*\n_User name: _ "..user_name.."\n_User Id:_ *"..data.id_.."*", 0, "md")
   else
     return tdcli.sendMessage(arg.chat_id, "", 0, "_خطا❢_\n`کاربرازتمام گروه های ربات محروم نبود`\n`اطلاعات کاربر:`\n _یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
      end
   end
  administration['gban_users'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
    if not lang then
     return tdcli.sendMessage(arg.chat_id, "", 0, "*Done!*\n`User has been Globally unBaned`\n*User Info:*\n_User name:_ "..user_name.."\n_User Id:_ *"..data.id_.."*", 0, "md")
   else
     return tdcli.sendMessage(arg.chat_id, "", 0, "_انجام شد!_\n`کاربر از محرومیت گروه های ربات خارج شد`\n `اطلاعات کاربر:`\n _یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
   end
end
  if cmd == "kick" then
   if is_mod1(arg.chat_id, data.id_) then
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\nYou can't *kick*\n`【✶Mods,✷Owners & ❈BotAdmins】`", 0, "md")
    elseif lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_اخطار❢_\n_شما نمیتوانید افراد ذیل شده را اخراج کنید_\n`【✶مدیران,✷اونر ها & ❈ادمین های ربات】`", 0, "md")
   end
  else
     kick_user(data.id_, arg.chat_id)
     end
  end
  if cmd == "delall" then
   if is_mod1(arg.chat_id, data.id_) then
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\nYou can't *delete chat*\n`【✶Mods,✷Owners & ❈BotAdmins】`", 0, "md")
   elseif lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_اخطار❢_\n_شما نمیتوانید پیام افراد ذیل شده را پاک کنید_\n`【✶مدیران,✷اونر ها & ❈ادمین های ربات】`", 0, "md")
   end
  else
tdcli.deleteMessagesFromUser(arg.chat_id, data.id_, dl_cb, nil)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "*Done!*\n`All messages this User has been deleted`\n*User Info:*\n_User Id:_ *"..data.id_.."*", 0, "md")
      elseif lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_انجام شد!_\n`تمام پیام های این کاربر پاک شد`\n_آیدی:_ *"..data.id_.."*", 0, "md")
       end
    end
  end
else
    if lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_خطا❢_\n`کاربر در گروه وجود ندارد`", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "Error❢*\n`User Not Found this group`", 0, "md")
      end
   end
   local function delmsg (arg,data)
for k,v in pairs(data.messages_) do
tdcli.deleteMessages(v.chat_id_,{[0] = v.id_})
end
end

local text85 = io.popen("sh ./data/cmd.sh"):read('*all')
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
  if not administration[tostring(arg.chat_id)] then
  if not lang then
    return tdcli.sendMessage(data.chat_id_, "", 0, "⚠️_Group is not added_⚠️", 0, "md")
else
    return tdcli.sendMessage(data.chat_id_, "", 0, "_گروه به لیست گروه های مدیریتی ربات اضافه نشده است_", 0, "md")
     end
  end
if not arg.username then return false end
   if data.id_ then
if data.type_.user_.username_ then
user_name = '@'..check_markdown(data.type_.user_.username_)
else
user_name = check_markdown(data.title_)
end
if cmd == "setowner" then
if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\n`User is already a group owner`\n*userinfo:*\n_username:_ "..user_name.."\n_userid:_ *"..data.id_.."*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_اخطار❢_\n`کاربر از قبل صاحب گروه بود`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "*Done!*\n`User is now the group owner`\n*userinfo:*\n_username:_"..user_name.."\n_userid:_*"..data.id_.."*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "_انجام شد!_\n`کاربر به مقام صاحب گروه منتصب شد`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
   end
end
  if cmd == "modset" then
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\n`User is already a moderator`\n*userinfo:*\n_username:_ "..user_name.."\n_userid:_ *"..data.id_.."*", 0, "md")
else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_اخطار❢_\n`کاربر از قبل مدیر گروه بود`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*Done!*\n`User has been promoted`\n*userinfo:*\n_username:_"..user_name.."\n_userid:_*"..data.id_.."*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_انجام شد!_\n`کاربر به مقام مدیر گروه منتصب شد`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
   end
end
   if cmd == "remowner" then
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\n`User is not a group owner`\n*userinfo:*\n_username:_"..user_name.."\n_userid:_*"..data.id_.."*", 0, "md")
   else
return tdcli.sendMessage(arg.chat_id, "", 0, "_اخطار❢_\n`کاربر از قبل صاحب گروه نبود`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "*Done!*\n`User is no longer a group owner`\n*userinfo:*\n_username:_"..user_name.."\n_userid:_*"..data.id_.."*", 0, "md")
    else
return tdcli.sendMessage(arg.chat_id, "", 0, "_انجام شد!_\n`کاربراز مقام صاحب گروه برکنار شد`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
   end
end
   if cmd == "moddem" then
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\n`User is not a moderator`\n*userinfo:*\n_username:_"..user_name.."\n_userid:_*"..data.id_.."*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_اخطار❢_\n`کاربر از قبل مدیر گروه نبود`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
   end
  end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*Done!*\n`User has been demoted`\n*userinfo:*\n_username:_"..user_name.."\n_userid:_*"..data.id_.."*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_انجام شد!_\n`کاربر از مقام مدیر گروه برکنار شد`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
   end
end
   if cmd == "userid" then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*"..data.id_.."*", 0, "md")
end
    if cmd == "res" then
    if not lang then
     text = "Result for [ "..check_markdown(data.type_.user_.username_).." ] :\n"
    .. ""..check_markdown(data.title_).."\n"
    .. " ["..data.id_.."]"
  else
     text = "اطلاعات برای [ "..check_markdown(data.type_.user_.username_).." ] :\n"
    .. "".. check_markdown(data.title_) .."\n"
    .. " [".. data.id_ .."]"
         end
       return tdcli.sendMessage(arg.chat_id, 0, 1, text, 1, 'md')
   end
else
    if lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر یافت نشد_", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "*User Not Found*", 0, "md")
      end
   end
end

local function action_by_id(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local cmd = arg.cmd
if not tonumber(arg.user_id) then return false end
   if data.id_ then
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
    if cmd == "adminprom" then
if is_admin1(tonumber(data.id_)) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_User_ "..user_name.." *"..data.id_.."* _is already an_ *admin*", 0, "md")
  else
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_کاربر_ "..user_name.." *"..data.id_.."* _از قبل ادمین ربات بود_", 0, "md")
      end
   end
	    table.insert(_config.admins, {tonumber(data.id_), user_name})
		save_config()
     if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_User_ "..user_name.." *"..data.id_.."* _has been promoted as_ *admin*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_کاربر_ "..user_name.." *"..data.id_.."* _به مقام ادمین ربات منتصب شد_", 0, "md")
   end
end 
    if cmd == "admindem" then
	local nameid = index_function(tonumber(data.id_))
if not is_admin1(data.id_) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_User_ "..user_name.." *"..data.id_.."* _is not a_ *admin*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_کاربر_ "..user_name.." *"..data.id_.."* _از قبل ادمین ربات نبود_", 0, "md")
      end
   end
		table.remove(_config.admins, nameid)
		save_config()
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_User_ "..user_name.." *"..data.id_.."* _has been demoted from_ *admin*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_کاربر_ "..user_name.." *"..data.id_.."* _از مقام ادمین ربات برکنار شد_", 0, "md")
   end
end
    if cmd == "visudo" then
if already_sudo(tonumber(data.id_)) then
  if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_User_ "..user_name.." *"..data.id_.."* _is already a_ *sudoer*👤", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_کاربر_ "..user_name.." *"..data.id_.."* _از قبل سودو ربات بود_👤", 0, "md")
      end
   end
          table.insert(_config.sudo_users, tonumber(data.id_))
		save_config()
     reload_plugins(true)
  if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_User_ "..user_name.." *"..data.id_.."* _is now_ *sudoer*👤", 0, "md")
  else
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_کاربر_ "..user_name.." *"..data.id_.."* _به مقام سودو ربات منتصب شد_👤", 0, "md")
   end
end
    if cmd == "desudo" then
     if not already_sudo(data.id_) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_User_ "..user_name.." *"..data.id_.."* _is not a_ *sudoer*❌👤", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_کاربر_ "..user_name.." *"..data.id_.."* _از قبل سودو ربات نبود_❌👤", 0, "md")
      end
   end
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(data.id_)))
		save_config()
     reload_plugins(true) 
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_User_ "..user_name.." *"..data.id_.."* _is no longer a_ *sudoer*❌👤", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "》_کاربر_ "..user_name.." *"..data.id_.."* _از مقام سودو ربات برکنار شد_❌👤", 0, "md")
      end
   end
else
    if lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر یافت نشد_", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "*User Not Found*", 0, "md")
      end
   end
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
  if not administration[tostring(arg.chat_id)] then
  if not lang then
    return tdcli.sendMessage(data.chat_id_, "", 0, "⚠️_Group is not added_⚠️", 0, "md")
else
    return tdcli.sendMessage(data.chat_id_, "", 0, "_گروه به لیست گروه های مدیریتی ربات اضافه نشده است_", 0, "md")
     end
  end
if not tonumber(arg.user_id) then return false end
   if data.id_ then
if data.first_name_ then
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
  if cmd == "setowner" then
  if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\n`User is already a group owner`\n*userinfo:*\n_username:_ "..user_name.."\n_userid:_ *"..data.id_.."*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_اخطار❢_\n`کاربر از قبل صاحب گروه بود`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "*Done!*\n`User is now the group owner`\n*userinfo:*\n_username:_"..user_name.."\n_userid:_*"..data.id_.."*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "_انجام شد!_\n`کاربر به مقام صاحب گروه منتصب شد`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
   end
end
  if cmd == "modset" then
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\n`User is already a moderator`\n*userinfo:*\n_username:_ "..user_name.."\n_userid:_ *"..data.id_.."*", 0, "md")
else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_اخطار❢_\n`کاربر از قبل مدیر گروه بود`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*Done!*\n`User has been promoted`\n*userinfo:*\n_username:_"..user_name.."\n_userid:_*"..data.id_.."*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_انجام شد!_\n`کاربر به مقام مدیر گروه منتصب شد`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
   end
end
   if cmd == "remowner" then
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\n`User is not a group owner`\n*userinfo:*\n_username:_"..user_name.."\n_userid:_*"..data.id_.."*", 0, "md")
   else
return tdcli.sendMessage(arg.chat_id, "", 0, "_اخطار❢_\n`کاربر از قبل صاحب گروه نبود`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "*Done!*\n`User is no longer a group owner`\n*userinfo:*\n_username:_"..user_name.."\n_userid:_*"..data.id_.."*", 0, "md")
    else
return tdcli.sendMessage(arg.chat_id, "", 0, "_انجام شد!_\n`کاربراز مقام صاحب گروه برکنار شد`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
   end
end
   if cmd == "moddem" then
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*Error❢*\n`User is not a moderator`\n*userinfo:*\n_username:_"..user_name.."\n_userid:_*"..data.id_.."*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_اخطار❢_\n`کاربر از قبل مدیر گروه نبود`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
   end
  end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*Done!*\n`User has been demoted`\n*userinfo:*\n_username:_"..user_name.."\n_userid:_*"..data.id_.."*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_انجام شد!_\n`کاربر از مقام مدیر گروه برکنار شد`\n`اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
   end
end
    if cmd == "whois" then
if data.username_ then
username = '@'..check_markdown(data.username_)
else
if not lang then
username = 'not found'
 else
username = 'ندارد'
  end
end
     if not lang then
       return tdcli.sendMessage(arg.chat_id, 0, 1, '*Id* : `[ '..data.id_..' ]`\n*UserName* : '..username..'\n*Name* : '..data.first_name_, 1)
   else
       return tdcli.sendMessage(arg.chat_id, 0, 1, '_آیدی_ : `[ '..data.id_..' ]` \n_یوزرنیم_ : '..username..'\n_نام_ : '..data.first_name_, 1)
      end
   end
 else
    if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_User not founded_", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر یافت نشد_", 0, "md")
    end
  end
else
    if lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر یافت نشد_", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "*User Not Found*", 0, "md")
      end
   end
end


---------------Lock Link-------------------
local function lock_link(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "❗️_You're Not_ *Moderator*❗️"
else
 return "❗️شما مدیر گروه نمیباشید❗️"
end
end

local lock_link = data[tostring(target)]["settings"]["lock_link"] 
if lock_link == "yes" then
if not lang then
 return "`Error❢` \n📄*Link* _Posting Is Already Locked_🔒"
elseif lang then
 return "`اخطار❢`\n📄ارسال لینک در گروه هم اکنون ممنوع است🔒"
end
else
data[tostring(target)]["settings"]["lock_link"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "`Done!` \n📄*Link* _Posting Has Been Locked_🔒"
else
 return "`انجام شد!`\n📄ارسال لینک در گروه ممنوع شد🔒"
end
end
end

local function unlock_link(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "❗️_You're Not_ *Moderator*❗️"
else
return "❗️شما مدیر گروه نمیباشید❗️"
end
end 

local lock_link = data[tostring(target)]["settings"]["lock_link"]
 if lock_link == "no" then
if not lang then
return "`Error❢` \n📄*Link* _Posting Is Not Locked_🔓" 
elseif lang then
return "`اخطار❢`\n📄ارسال لینک در گروه ممنوع نمیباشد🔓"
end
else 
data[tostring(target)]["settings"]["lock_link"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "`Done!` \n📄*Link* _Posting Has Been Unlocked_🔓" 
else
return "`انجام شد!`\n📄ارسال لینک در گروه آزاد شد🔓"
end
end
end

---------------Lock Tag-------------------
local function lock_tag(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "❗️_You're Not_ *Moderator*❗️"
else
 return "❗️شما مدیر گروه نمیباشید❗️"
end
end

local lock_tag = data[tostring(target)]["settings"]["lock_tag"] 
if lock_tag == "yes" then
if not lang then
 return "`Error❢` \n🏷*Tag* _Posting Is Already Locked_🔒"
elseif lang then
 return "`اخطار❢`\n🏷ارسال تگ در گروه هم اکنون ممنوع است🔒"
end
else
 data[tostring(target)]["settings"]["lock_tag"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "`Done!` \n🏷*Tag* _Posting Has Been Locked_🔒"
else
 return "`انجام شد!`\n🏷ارسال تگ در گروه ممنوع شد🔒"
end
end
end

local function unlock_tag(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "❗️_You're Not_ *Moderator*❗️"
else
 return "❗️شما مدیر گروه نمیباشید❗️"
end 
end

local lock_tag = data[tostring(target)]["settings"]["lock_tag"]
 if lock_tag == "no" then
if not lang then
return "`Error❢` \n🏷*Tag* _Posting Is Not Locked_🔓" 
elseif lang then
return "`اخطار❢`\n🏷ارسال تگ در گروه ممنوع نمیباشد🔓"
end
else 
data[tostring(target)]["settings"]["lock_tag"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "`Done!` \n🏷*Tag* _Posting Has Been Unlocked_🔓" 
else
return "`انجام شد!`\n🏷ارسال تگ در گروه آزاد شد🔓"
end
end
end

---------------Lock Mention-------------------
local function lock_mention(msg, data, target)
 local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "❗️_You're Not_ *Moderator*❗️"
else
 return "❗️شما مدیر گروه نمیباشید❗️"
end
end

local lock_mention = data[tostring(target)]["settings"]["lock_mention"] 
if lock_mention == "yes" then
if not lang then
 return "`Error❢` \n🔸*Mention* _Posting Is Already Locked_🔒"
elseif lang then
 return "`اخطار❢`\n🔸ارسال فراخوانی افراد هم اکنون ممنوع است🔒"
end
else
 data[tostring(target)]["settings"]["lock_mention"] = "yes"
save_data(_config.moderation.data, data)
if not lang then 
 return "`Done!` \n🔸*Mention* _Posting Has Been Locked_🔒"
else 
 return "`انجام شد!`\n🔸ارسال فراخوانی افراد در گروه ممنوع شد🔒"
end
end
end

local function unlock_mention(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "❗️_You're Not_ *Moderator*❗️"
else
return "❗️شما مدیر گروه نمیباشید❗️"
end
end 

local lock_mention = data[tostring(target)]["settings"]["lock_mention"]
 if lock_mention == "no" then
if not lang then
return "`Error❢` \n🔸*Mention* _Posting Is Not Locked_🔓" 
elseif lang then
return "`اخطار❢`\n🔸ارسال فراخوانی افراد در گروه ممنوع نمیباشد🔓"
end
else 
data[tostring(target)]["settings"]["lock_mention"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "`Done!` \n🔸*Mention* _Posting Has Been Unlocked_🔓" 
else
return "`انجام شد!`\n🔸ارسال فراخوانی افراد در گروه آزاد شد🔓"
end
end
end

---------------Lock Arabic--------------
local function lock_arabic(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "❗️_You're Not_ *Moderator*❗️"
else
 return "❗️شما مدیر گروه نمیباشید❗️"
end
end

local lock_arabic = data[tostring(target)]["settings"]["lock_arabic"] 
if lock_arabic == "yes" then
if not lang then
 return "`Error❢` \n🇸🇦*Arabic/Persian* _Posting Is Already Locked_🔒"
elseif lang then
 return "`اخطار❢`\n🇸🇦ارسال کلمات عربی/فارسی در گروه هم اکنون ممنوع است🔒"
end
else
data[tostring(target)]["settings"]["lock_arabic"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "`Done!` \n🇸🇦*Arabic/Persian* _Posting Has Been Locked_🔒"
else
 return "`انجام شد!`\n🇸🇦ارسال کلمات عربی/فارسی در گروه ممنوع شد🔒"
end
end
end

local function unlock_arabic(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "❗️_You're Not_ *Moderator*❗️"
else
return "❗️شما مدیر گروه نمیباشید❗️"
end
end 

local lock_arabic = data[tostring(target)]["settings"]["lock_arabic"]
 if lock_arabic == "no" then
if not lang then
return "`Error❢` \n🇸🇦*Arabic/Persian* _Posting Is Not Locked_🔓" 
elseif lang then
return "`اخطار❢`\n🇸🇦ارسال کلمات عربی/فارسی در گروه ممنوع نمیباشد🔓"
end
else 
data[tostring(target)]["settings"]["lock_arabic"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "`Done!` \n🇸🇦*Arabic/Persian* _Posting Has Been Unlocked_🔓" 
else
return "`انجام شد!`\n🇸🇦ارسال کلمات عربی/فارسی در گروه آزاد شد🔓"
end
end
end

---------------Lock Edit-------------------
local function lock_edit(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "❗️_You're Not_ *Moderator*❗️"
else
 return "❗️شما مدیر گروه نمیباشید❗️"
end
end

local lock_edit = data[tostring(target)]["settings"]["lock_edit"] 
if lock_edit == "yes" then
if not lang then
 return "`Error❢` \n📝*Editing* _Is Already Locked_🔒"
elseif lang then
 return "`اخطار❢`\n📝ویرایش پیام هم اکنون ممنوع است🔒"
end
else
 data[tostring(target)]["settings"]["lock_edit"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "`Done!` \n📝*Editing* _Has Been Locked_🔒"
else
 return "`انجام شد!`\n📝ویرایش پیام در گروه ممنوع شد🔒"
end
end
end

local function unlock_edit(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "❗️_You're Not_ *Moderator*❗️"
else
return "❗️شما مدیر گروه نمیباشید❗️"
end
end 

local lock_edit = data[tostring(target)]["settings"]["lock_edit"]
 if lock_edit == "no" then
if not lang then
return "`Error❢` \n📝*Editing* _Is Not Locked_🔓" 
elseif lang then
return "`اخطار❢`\n📝ویرایش پیام در گروه ممنوع نمیباشد🔓"
end
else 
data[tostring(target)]["settings"]["lock_edit"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "`Done!` \n📝*Editing* _Has Been Unlocked_🔓" 
else
return "`انجام شد!`\n📝ویرایش پیام در گروه آزاد شد🔓"
end
end
end

---------------Lock spam-------------------
local function lock_spam(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "❗️_You're Not_ *Moderator*❗️"
else
 return "❗️شما مدیر گروه نمیباشید❗️"
end
end

local lock_spam = data[tostring(target)]["settings"]["lock_spam"] 
if lock_spam == "yes" then
if not lang then
 return "`Error❢` \n📃*Spam* _Is Already Locked_🔒"
elseif lang then
 return "`اخطار❢`\n📃ارسال هرزنامه در گروه هم اکنون ممنوع است🔒"
end
else
 data[tostring(target)]["settings"]["lock_spam"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "`Done!` \n📃*Spam* _Has Been Locked_🔒"
else
 return "`انجام شد!`\n📃ارسال هرزنامه در گروه ممنوع شد🔒"
end
end
end

local function unlock_spam(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "❗️_You're Not_ *Moderator*❗️"
else
return "❗️شما مدیر گروه نمیباشید❗️"
end
end 

local lock_spam = data[tostring(target)]["settings"]["lock_spam"]
 if lock_spam == "no" then
if not lang then
return "`Error❢` \n📃*Spam* _Posting Is Not Locked_🔓" 
elseif lang then
 return "`اخطار❢`\n📃ارسال هرزنامه در گروه ممنوع نمیباشد🔓"
end
else 
data[tostring(target)]["settings"]["lock_spam"] = "no" 
save_data(_config.moderation.data, data)
if not lang then 
return "`Done!` \n📃*Spam* _Posting Has Been Unlocked_🔓" 
else
 return "`انجام شد!`\n📃ارسال هرزنامه در گروه آزاد شد🔓"
end
end
end

---------------Lock Flood-------------------
local function lock_flood(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "❗️_You're Not_ *Moderator*❗️"
else
 return "❗️شما مدیر گروه نمیباشید❗️"
end
end

local lock_flood = data[tostring(target)]["settings"]["flood"] 
if lock_flood == "yes" then
if not lang then
 return "`Error❢` \n☠*Flooding* _Is Already Locked_🔒"
elseif lang then
 return "`اخطار❢`\n☠ارسال پیام مکرر در گروه هم اکنون ممنوع است🔒"
end
else
 data[tostring(target)]["settings"]["flood"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "`Done!` \n☠*Flooding* _Has Been Locked_🔒"
else
 return "`انجام شد!`\n☠ارسال پیام مکرر در گروه ممنوع شد🔒"
end
end
end

local function unlock_flood(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "❗️_You're Not_ *Moderator*❗️"
else
return "❗️شما مدیر گروه نمیباشید❗️"
end
end 

local lock_flood = data[tostring(target)]["settings"]["flood"]
 if lock_flood == "no" then
if not lang then
return "`Error❢` \n☠*Flooding* _Is Not Locked_🔓" 
elseif lang then
return "`اخطار❢`\n☠ارسال پیام مکرر در گروه ممنوع نمیباشد🔓"
end
else 
data[tostring(target)]["settings"]["flood"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "`Done!` \n☠*Flooding* _Has Been Unlocked_🔓" 
else
return "`انجام شد!`\n☠ارسال پیام مکرر در گروه آزاد شد🔓"
end
end
end

---------------Lock Bots-------------------
local function lock_bots(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "❗️_You're Not_ *Moderator*❗️"
else
 return "❗️شما مدیر گروه نمیباشید❗️"
end
end

local lock_bots = data[tostring(target)]["settings"]["lock_bots"] 
if lock_bots == "yes" then
if not lang then
 return "`Error❢` \n🤖*Bots* _Protection Is Already Enabled_🔒"
elseif lang then
 return "`اخطار❢`\n🤖محافظت از گروه در برابر ربات ها هم اکنون فعال است🔒"
end
else
 data[tostring(target)]["settings"]["lock_bots"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "`Done!` \n*🤖Bots* _Protection Has Been Enabled_🔒"
else
 return "`انجام شد!`\n🤖محافظت از گروه در برابر ربات ها فعال شد🔒"
end
end
end

local function unlock_bots(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "❗️_You're Not_ *Moderator*❗️"
else
return "❗️شما مدیر گروه نمیباشید❗️"
end 
end

local lock_bots = data[tostring(target)]["settings"]["lock_bots"]
 if lock_bots == "no" then
if not lang then
return "`Error❢` \n🤖*Bots* _Protection Is Not Enabled_🔓" 
elseif lang then
return "`اخطار❢`\n🤖محافظت از گروه در برابر ربات ها غیر فعال است🔓"
end
else 
data[tostring(target)]["settings"]["lock_bots"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "`Done!` \n🤖*Bots* _Protection Has Been Disabled_🔓" 
else
return "`انجام شد!`\n🤖محافظت از گروه در برابر ربات ها غیر فعال شد🔓"
end
end
end

---------------Lock Markdown-------------------
local function lock_markdown(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "❗️_You're Not_ *Moderator*❗️"
else
 return "❗️شما مدیر گروه نمیباشید❗️"
end
end

local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"] 
if lock_markdown == "yes" then
if not lang then 
 return "`Error❢` \nℹ️*Markdown* _Posting Is Already Locked_🔒"
elseif lang then
 return "`اخطار❢`\nℹ️ارسال پیام های دارای فونت در گروه هم اکنون ممنوع است🔒"
end
else
 data[tostring(target)]["settings"]["lock_markdown"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "`Done!` \nℹ️*Markdown* _Posting Has Been Locked_🔒"
else
 return "`انجام شد!`\nℹ️ارسال پیام های دارای فونت در گروه ممنوع شد🔒"
end
end
end

local function unlock_markdown(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "❗️_You're Not_ *Moderator*❗️"
else
return "❗️شما مدیر گروه نمیباشید❗️"
end 
end

local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"]
 if lock_markdown == "no" then
if not lang then
return "`Error❢` \nℹ️*Markdown* _Posting Is Not Locked_🔓"
elseif lang then
return "`اخطار❢`\nℹ️ارسال پیام های دارای فونت در گروه ممنوع نمیباشد🔓"
end
else 
data[tostring(target)]["settings"]["lock_markdown"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "`Done!` \nℹ️*Markdown* _Posting Has Been Unlocked_🔓"
else
return "`انجام شد!`\nℹ️ارسال پیام های دارای فونت در گروه آزاد شد🔓"
end
end
end

---------------Lock Webpage-------------------
local function lock_webpage(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "❗️_You're Not_ *Moderator*❗️"
else
 return "❗️شما مدیر گروه نمیباشید❗️"
end
end

local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"] 
if lock_webpage == "yes" then
if not lang then
 return "`Error❢` \n📰*Webpage* _Is Already Locked_🔒"
elseif lang then
 return "`اخطار❢`\n📰ارسال صفحات وب در گروه هم اکنون ممنوع است🔒"
end
else
 data[tostring(target)]["settings"]["lock_webpage"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "`Done!` \n📰*Webpage* _Has Been Locked_🔒"
else
 return "`انجام شد!`\n📰ارسال صفحات وب در گروه ممنوع شد🔒"
end
end
end

local function unlock_webpage(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "❗️_You're Not_ *Moderator*❗️"
else
return "❗️شما مدیر گروه نمیباشید❗️"
end 
end

local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"]
 if lock_webpage == "no" then
if not lang then
return "`Error❢` \n📰*Webpage* _Is Not Locked_🔓" 
elseif lang then
return "`اخطار❢`\n📰ارسال صفحات وب در گروه ممنوع نمیباشد🔓"
end
else 
data[tostring(target)]["settings"]["lock_webpage"] = "no"
save_data(_config.moderation.data, data) 
if not lang then
return "`Done!` \n📰*Webpage* _Has Been Unlocked_🔓" 
else
return "`انجام شد!`\n📰ارسال صفحات وب در گروه آزاد شد🔓"
end
end
end

---------------Lock Pin-------------------
local function lock_pin(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "❗️_You're Not_ *Moderator*❗️"
else
 return "❗️شما مدیر گروه نمیباشید❗️"
end
end

local lock_pin = data[tostring(target)]["settings"]["lock_pin"] 
if lock_pin == "yes" then
if not lang then
 return "`Error❢` \n📌*Pinned Message* _Is Already Locked_🔒"
elseif lang then
 return "`اخطار❢`\n📌سنجاق کردن پیام در گروه هم اکنون ممنوع است🔒"
end
else
 data[tostring(target)]["settings"]["lock_pin"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "`Done!` \n📌*Pinned Message* _Has Been Locked_🔒"
else
 return "`انجام شد!`\n📌سنجاق کردن پیام در گروه ممنوع شد🔒"
end
end
end

local function unlock_pin(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "❗️_You're Not_ *Moderator*❗️"
else
return "❗️شما مدیر گروه نمیباشید❗️"
end 
end

local lock_pin = data[tostring(target)]["settings"]["lock_pin"]
 if lock_pin == "no" then
if not lang then
return "`Error❢` \n📌*Pinned Message* _Is Not Locked_🔓" 
elseif lang then
return "`اخطار❢`\n📌سنجاق کردن پیام در گروه ممنوع نمیباشد🔓"
end
else 
data[tostring(target)]["settings"]["lock_pin"] = "no"
save_data(_config.moderation.data, data) 
if not lang then
return "`Done!` \n📌*Pinned Message* _Has Been Unlocked_🔓" 
else
return "`انجام شد!`\n📌سنجاق کردن پیام در گروه آزاد شد🔓"
end
end
end

function group_settings(msg, target) 	
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 	return "🍆😑gσн кнσя∂ι ѕєттιηg zα∂ι😂"
else
  return "🍆ڳہ ݗۏڔدۍ ښݓيݧڱ زڋے😑😂"
end
end
local data = load_data(_config.moderation.data)
local target = msg.to.id 
if data[tostring(target)] then 	
if data[tostring(target)]["settings"]["num_msg_max"] then 	
NUM_MSG_MAX = tonumber(data[tostring(target)]['settings']['num_msg_max'])
	print('custom'..NUM_MSG_MAX) 	
else 	
NUM_MSG_MAX = 5
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_link"] then			
data[tostring(target)]["settings"]["lock_link"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_tag"] then			
data[tostring(target)]["settings"]["lock_tag"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_mention"] then			
data[tostring(target)]["settings"]["lock_mention"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_arabic"] then			
data[tostring(target)]["settings"]["lock_arabic"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_edit"] then			
data[tostring(target)]["settings"]["lock_edit"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_spam"] then			
data[tostring(target)]["settings"]["lock_spam"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_flood"] then			
data[tostring(target)]["settings"]["lock_flood"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_bots"] then			
data[tostring(target)]["settings"]["lock_bots"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_markdown"] then			
data[tostring(target)]["settings"]["lock_markdown"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_webpage"] then			
data[tostring(target)]["settings"]["lock_webpage"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["welcome"] then			
data[tostring(target)]["settings"]["welcome"] = "no"		
end
end

 if data[tostring(target)]["settings"] then		
 if not data[tostring(target)]["settings"]["lock_pin"] then			
 data[tostring(target)]["settings"]["lock_pin"] = "no"		
 end
 end
if not lang then
		 local exp = redis:get("charged:"..msg.chat_id_)
    local day = 86400
    local ex = redis:ttl("charged:"..msg.chat_id_)
       if not exp or ex == -1 then
        expireen = " Unlimited "
       else
        local d = math.floor(ex / day ) + 1
       expireen = " "..d.." day"
   end

local settings = data[tostring(target)]["settings"] 
 text = "*Group Settings*  :\n\n`【`*Lock edit*`】`*➤* `"..settings.lock_edit.."` \n`【`*Lock links*`】`*➤* `"..settings.lock_link.."` \n`【`*Lock tags*`】`*➤* `"..settings.lock_tag.."` \n`【`*Lock flood*`】`*➤* `"..settings.flood.."` \n`【`*Lock spam*`】`*➤* `"..settings.lock_spam.."`\n`【`*Lock mention*`】`*➤* `"..settings.lock_mention.."` \n`【`*Lock arabic*`】`*➤* `"..settings.lock_arabic.."`\n`【`*Lock webpage*`】`*➤* `"..settings.lock_webpage.."` \n`【`*Lock markdown*`】`*➤* `"..settings.lock_markdown.."`\n`【`*Group welcome*`】`*➤* `"..settings.welcome.."` \n`【`*Lock pin message*`】`*➤* `"..settings.lock_pin.."` \n`【`*Bots protection*`】`*➤* `"..settings.lock_bots.."` \n`【`*Flood sensitivity*`】`*➤* `"..NUM_MSG_MAX.."` \n`【`*Expire date*`】`*➤* `"..expireen.."` \n*____________________*\n`₰`*Bot channel*`₰` *:* `:D` \n*➖➖➖➖➖➖➖➖➖*\n`⇈`*Group Language*`⇈` *:* `EN`\n*➖➖➖➖➖➖➖➖➖*\n`₰`*group name* `₰` *:*  `"..msg.to.title.."`\n`₰`*group id*`₰` *:*  `"..chat.."` "
else
		 local exp = redis:get("charged:"..msg.chat_id_)
    local ex = redis:ttl("charged:"..msg.chat_id_)
       if not exp or ex == -1 then
        expirefa = "نامحدود"
       else
        local d = math.floor(ex / day ) + 1
       expirefa = " "..d.." روز"
   end


local settings = data[tostring(target)]["settings"] 
 text = "_تنظیمات گروه_ :\n\n`【`_قفل ویرایش پیام_`】` : `"..settings.lock_edit.."`\n`【`_قفل لینک_`】` : `"..settings.lock_link.."`\n`【`_قفل تگ_`】` : `"..settings.lock_tag.."`\n`【`_قفل پیام مکرر_`】` : `"..settings.flood.."`\n`【`_قفل هرزنامه_`】` : `"..settings.lock_spam.."`\n`【`_قفل فراخوانی_`】` : `"..settings.lock_mention.."`\n`【`_قفل عربی_`】` : `"..settings.lock_arabic.."`\n`【`_قفل صفحات وب_`】` : `"..settings.lock_webpage.."`\n`【`_قفل فونت_`】` : `"..settings.lock_markdown.."`\n`【`_پیام خوشآمد گویی_`】` : `"..settings.welcome.."`\n`【`_قفل سنجاق کردن_`】` : `"..settings.lock_pin.."`\n`【`_محافظت در برابر ربات ها_`】` : `"..settings.lock_bots.."`\n`【`_حداکثر پیام مکرر_`】` : `"..NUM_MSG_MAX.."`\n`【`_تاریخ انقضا_`】` : `"..expirefa.."`\n*____________________*\n `₰` _کانال ما_ `₰`: `:D`\n*➖➖➖➖➖➖➖➖➖*\n `⇈` _زبان سوپرگروه_ `⇈` : *FA*\n*➖➖➖➖➖➖➖➖➖*\n `₰` _نام گروه_ `₰` : `"..msg.to.title.."`\n `₰` _آیدی گروه_ `₰` : `"..chat.."`"
end
return text
end
--------Mutes---------
--------Mute all--------------------------
local function mute_all(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then 
if not lang then
return "❗️_You're Not_ *Moderator*❗️" 
else
return "❗️شما مدیر گروه نمیباشید❗️"
end
end

local mute_all = data[tostring(target)]["mutes"]["mute_all"] 
if mute_all == "yes" then 
if not lang then
return "`Error❢` \n👥*Mute All* _Is Already Enabled_🔇" 
elseif lang then
return "`اخطار❢`\n👥بیصدا کردن همه فعال است🔇"
end
else 
data[tostring(target)]["mutes"]["mute_all"] = "yes"
 save_data(_config.moderation.data, data) 
if not lang then
return "`Done!` \n👥*Mute All* _Has Been Enabled_🔇" 
else
return "`انجام شد!`\n👥بیصدا کردن همه فعال شد🔇"
end
end
end

local function unmute_all(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then 
if not lang then
return "❗️_You're Not_ *Moderator*❗️" 
else
return "❗️شما مدیر گروه نمیباشید❗️"
end
end

local mute_all = data[tostring(target)]["mutes"]["mute_all"] 
if mute_all == "no" then 
if not lang then
return "`Error❢` \n👥*Mute All* _Is Already Disabled_🔊" 
elseif lang then
return "`اخطار❢`\n👥بیصدا کردن همه غیر فعال است🔊"
end
else 
data[tostring(target)]["mutes"]["mute_all"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "`Done!` \n👥*Mute All* _Has Been Disabled_🔊" 
else
return "`انجام شد!`\n👥بیصدا کردن همه غیر فعال شد🔊"
end 
end
end

---------------Mute Gif-------------------
local function mute_gif(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "❗️_You're Not_ *Moderator*❗️"
else
 return "❗️شما مدیر گروه نمیباشید❗️"
end
end

local mute_gif = data[tostring(target)]["mutes"]["mute_gif"] 
if mute_gif == "yes" then
if not lang then
 return "`Error❢` \n🎆*Mute Gif* _Is Already Enabled_🔇"
elseif lang then
 return "`اخطار❢`\n🎆بیصدا کردن تصاویر متحرک فعال است🔇"
end
else
 data[tostring(target)]["mutes"]["mute_gif"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then 
 return "`Done!` \n🎆*Mute Gif* _Has Been Enabled_🔇"
else
 return "`انجام شد!`\n🎆بیصدا کردن تصاویر متحرک فعال شد🔇"
end
end
end

local function unmute_gif(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "❗️_You're Not_ *Moderator*❗️"
else
return "❗️شما مدیر گروه نمیباشید❗️"
end
end 

local mute_gif = data[tostring(target)]["mutes"]["mute_gif"]
 if mute_gif == "no" then
if not lang then
return "`Error❢` \n🎆*Mute Gif* _Is Already Disabled_🔊" 
elseif lang then
return "🎆بیصدا کردن تصاویر متحرک غیر فعال بود🔊"
end
else 
data[tostring(target)]["mutes"]["mute_gif"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "`Done!` \n🎆*Mute Gif* _Has Been Disabled_🔊" 
else
return "`انجام شد!`\n🎆بیصدا کردن تصاویر متحرک غیر فعال شد🔊"
end
end
end
---------------Mute Game-------------------
local function mute_game(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "❗️_You're Not_ *Moderator*❗️"
else
 return "❗️شما مدیر گروه نمیباشید❗️"
end
end

local mute_game = data[tostring(target)]["mutes"]["mute_game"] 
if mute_game == "yes" then
if not lang then
 return "`Error❢` \n🎮*Mute Game* _Is Already Enabled_🔇"
elseif lang then
 return "`اخطار❢`\n🎮بیصدا کردن بازی های تحت وب فعال است🔇"
end
else
 data[tostring(target)]["mutes"]["mute_game"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "`Done!` \n🎮*Mute Game* _Has Been Enabled_🔇"
else
 return "`انجام شد!`\n🎮بیصدا کردن بازی های تحت وب فعال شد🔇"
end
end
end

local function unmute_game(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "❗️_You're Not_ *Moderator❗️*"
else
return "❗️شما مدیر گروه نمیباشید❗️"
end 
end

local mute_game = data[tostring(target)]["mutes"]["mute_game"]
 if mute_game == "no" then
if not lang then
return "`Error❢` \n🎮*Mute Game* _Is Already Disabled_🔊" 
elseif lang then
return "`اخطار❢`\n🎮بیصدا کردن بازی های تحت وب غیر فعال است🔊"
end
else 
data[tostring(target)]["mutes"]["mute_game"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "`Done!` \n🎮*Mute Game* _Has Been Disabled_🔊" 
else
return "`انجام شد!`\n🎮بیصدا کردن بازی های تحت وب غیر فعال شد🔊"
end
end
end
---------------Mute Inline-------------------
local function mute_inline(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "❗️_You're Not_ *Moderator*❗️"
else
 return "❗️شما مدیر گروه نمیباشید❗️"
end
end

local mute_inline = data[tostring(target)]["mutes"]["mute_inline"] 
if mute_inline == "yes" then
if not lang then
 return "`Error❢` \n💎*Mute Inline* _Is Already Enabled_🔇"
elseif lang then
 return "`اخطار❢`\n💎بیصدا کردن کیبورد شیشه ای فعال است🔇"
end
else
 data[tostring(target)]["mutes"]["mute_inline"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "`Done!` \n💎*Mute Inline* _Has Been Enabled_🔇"
else
 return "`انجام شد!`\n💎بیصدا کردن کیبورد شیشه ای فعال شد🔇"
end
end
end

local function unmute_inline(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "❗️_You're Not_ *Moderator*❗️"
else
return "❗️شما مدیر گروه نمیباشید❗️"
end
end 

local mute_inline = data[tostring(target)]["mutes"]["mute_inline"]
 if mute_inline == "no" then
if not lang then
return "`Error❢` \n💎*Mute Inline* _Is Already Disabled_🔊" 
elseif lang then
return "`اخطار❢`\n💎بیصدا کردن کیبورد شیشه ای غیر فعال است🔊"
end
else 
data[tostring(target)]["mutes"]["mute_inline"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "`Done!` \n💎*Mute Inline* _Has Been Disabled_🔊" 
else
return "`انجام شد!`\n💎بیصدا کردن کیبورد شیشه ای غیر فعال شد🔊"
end
end
end
---------------Mute Text-------------------
local function mute_text(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "❗️_You're Not_ *Moderator*❗️"
else
 return "❗️شما مدیر گروه نمیباشید❗️"
end
end

local mute_text = data[tostring(target)]["mutes"]["mute_text"] 
if mute_text == "yes" then
if not lang then
 return "`Error❢` \n🗒*Mute Text* _Is Already Enabled_🔇"
elseif lang then
 return "`اخطار❢`\n🗒بیصدا کردن متن فعال است🔇"
end
else
 data[tostring(target)]["mutes"]["mute_text"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "`Done!` \n🗒*Mute Text* _Has Been Enabled_🔇"
else
 return "`انجام شد!`\n🗒بیصدا کردن متن فعال شد🔇"
end
end
end

local function unmute_text(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "❗️_You're Not_ *Moderator*❗️"
else
return "❗️شما مدیر گروه نمیباشید❗️"
end 
end

local mute_text = data[tostring(target)]["mutes"]["mute_text"]
 if mute_text == "no" then
if not lang then
return "`Error❢` \n🗒*Mute Text* _Is Already Disabled_🔊"
elseif lang then
return "`اخطار❢`\n🗒بیصدا کردن متن غیر فعال است🔊" 
end
else 
data[tostring(target)]["mutes"]["mute_text"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "`Done!` \n🗒*Mute Text* _Has Been Disabled_🔊" 
else
return "`انجام شد!`\n🗒بیصدا کردن متن غیر فعال شد🔊"
end
end
end
---------------Mute photo-------------------
local function mute_photo(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "❗️_You're Not_ *Moderator*❗️"
else
 return "❗️شما مدیر گروه نمیباشید❗️"
end
end

local mute_photo = data[tostring(target)]["mutes"]["mute_photo"] 
if mute_photo == "yes" then
if not lang then
 return "`Error❢` \n🌅*Mute Photo* _Is Already Enabled_🔇"
elseif lang then
 return "`اخطار❢`\n🌅بیصدا کردن عکس فعال است🔇"
end
else
 data[tostring(target)]["mutes"]["mute_photo"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "`Done!` \n🌅*Mute Photo* _Has Been Enabled_🔇"
else
 return "`انجام شد!`\n🌅بیصدا کردن عکس فعال شد🔇"
end
end
end

local function unmute_photo(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "❗️_You're Not_ *Moderator*❗️"
else
return "❗️شما مدیر گروه نمیباشید❗️"
end
end
 
local mute_photo = data[tostring(target)]["mutes"]["mute_photo"]
 if mute_photo == "no" then
if not lang then
return "`Error❢` \n🌅*Mute Photo* _Is Already Disabled_🔊" 
elseif lang then
return "`اخطار❢`\n🌅بیصدا کردن عکس غیر فعال است🔊"
end
else 
data[tostring(target)]["mutes"]["mute_photo"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "`Done!` \n🌅*Mute Photo* _Has Been Disabled_🔊" 
else
return "`انجام شد!`\n🌅بیصدا کردن عکس غیر فعال شد🔊"
end
end
end
---------------Mute Video-------------------
local function mute_video(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "❗️_You're Not_ *Moderator*❗️"
else
 return "❗️شما مدیر گروه نمیباشید❗️"
end
end

local mute_video = data[tostring(target)]["mutes"]["mute_video"] 
if mute_video == "yes" then
if not lang then
 return "`Error❢` \n📹*Mute Video* _Is Already Enabled_🔇"
elseif lang then
 return "`اخطار❢`\n📹بیصدا کردن فیلم فعال است🔇"
end
else
 data[tostring(target)]["mutes"]["mute_video"] = "yes" 
save_data(_config.moderation.data, data)
if not lang then 
 return "`Done!` \n📹*Mute Video* _Has Been Enabled_🔇"
else
 return "`انجام شد!`\n📹بیصدا کردن فیلم فعال شد🔇"
end
end
end

local function unmute_video(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "❗️_You're Not_ *Moderator*❗️"
else
return "❗️شما مدیر گروه نمیباشید❗️"
end
end 

local mute_video = data[tostring(target)]["mutes"]["mute_video"]
 if mute_video == "no" then
if not lang then
return "`Error❢` \n📹*Mute Video* _Is Already Disabled_🔊" 
elseif lang then
return "`اخطار❢`\n📹بیصدا کردن فیلم غیر فعال است🔊"
end
else 
data[tostring(target)]["mutes"]["mute_video"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "`Done!` \n📹*Mute Video* _Has Been Disabled_🔊" 
else
return "`انجام شد!`\n📹بیصدا کردن فیلم غیر فعال شد🔊"
end
end
end
---------------Mute Audio-------------------
local function mute_audio(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "❗️_You're Not_ *Moderator*❗️"
else
 return "❗️شما مدیر گروه نمیباشید❗️"
end
end

local mute_audio = data[tostring(target)]["mutes"]["mute_audio"] 
if mute_audio == "yes" then
if not lang then
 return "`Error❢` \n📣*Mute Audio* _Is Already Enabled_🔇"
elseif lang then
 return "`اخطار❢`\n📣بیصدا کردن آهنگ فعال است🔇"
end
else
 data[tostring(target)]["mutes"]["mute_audio"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "`Done!` \n📣*Mute Audio* _Has Been Enabled_🔇"
else 
return "`انجام شد!`\n📣بیصدا کردن آهنگ فعال شد🔇"
end
end
end

local function unmute_audio(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "❗️_You're Not_ *Moderator*❗️"
else
return "❗️شما مدیر گروه نمیباشید❗️"
end
end 

local mute_audio = data[tostring(target)]["mutes"]["mute_audio"]
 if mute_audio == "no" then
if not lang then
return "`Error❢` \n📣*Mute Audio* _Is Already Disabled_🔊" 
elseif lang then
return "`اخطار❢`\n📣بیصدا کردن آهنک غیر فعال است🔊"
end
else 
data[tostring(target)]["mutes"]["mute_audio"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "`Done!` \n📣*Mute Audio* _Has Been Disabled_🔊"
else
return "`انجام شد!`\n📣بیصدا کردن آهنگ غیر فعال شد🔊" 
end
end
end
---------------Mute Voice-------------------
local function mute_voice(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "❗️_You're Not_ *Moderator*❗️"
else
 return "❗️شما مدیر گروه نمیباشید❗️"
end
end

local mute_voice = data[tostring(target)]["mutes"]["mute_voice"] 
if mute_voice == "yes" then
if not lang then
 return "`Error❢` \n📢*Mute Voice* _Is Already Enabled_🔇"
elseif lang then
 return "`اخطار❢`\n📢بیصدا کردن صدا فعال است🔇"
end
else
 data[tostring(target)]["mutes"]["mute_voice"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "`Done!` \n📢*Mute Voice* _Has Been Enabled_🔇"
else
 return "`انجام شد!`\n📢بیصدا کردن صدا فعال شد🔇"
end
end
end

local function unmute_voice(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "❗️_You're Not_ *Moderator*❗️"
else
return "❗️شما مدیر گروه نمیباشید❗️"
end
end 

local mute_voice = data[tostring(target)]["mutes"]["mute_voice"]
 if mute_voice == "no" then
if not lang then
return "`Error❢` \n📢*Mute Voice* _Is Already Disabled_🔊" 
elseif lang then
return "`اخطار❢`\n📢بیصدا کردن صدا غیر فعال است🔊"
end
else 
data[tostring(target)]["mutes"]["mute_voice"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "`Done!` \n📢*Mute Voice* _Has Been Disabled_🔊" 
else
return "`انجام شد!`\n📢بیصدا کردن صدا غیر فعال شد🔊"
end
end
end
---------------Mute Sticker-------------------
local function mute_sticker(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "❗️_You're Not_ *Moderator*❗️"
else
 return "❗️شما مدیر گروه نمیباشید❗️"
end
end

local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"] 
if mute_sticker == "yes" then
if not lang then
 return "`Error❢` \n🎭*Mute Sticker* _Is Already Enabled_🔇"
elseif lang then
 return "`اخطار❢`\n🎭بیصدا کردن برچسب فعال است🔇"
end
else
 data[tostring(target)]["mutes"]["mute_sticker"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "`Done!` \n🎭*Mute Sticker* _Has Been Enabled_🔇"
else
 return "`انجام شد!`\n🎭بیصدا کردن برچسب فعال شد🔇"
end
end
end

local function unmute_sticker(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "❗️_You're Not_ *Moderator*❗️"
else
return "❗️شما مدیر گروه نمیباشید❗️"
end 
end

local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"]
 if mute_sticker == "no" then
if not lang then
return "`Error❢` \n🎭*Mute Sticker* _Is Already Disabled_🔊" 
elseif lang then
return "`اخطار❢`\n🎭بیصدا کردن برچسب غیر فعال است🔊"
end
else 
data[tostring(target)]["mutes"]["mute_sticker"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "`Done!` \n🎭*Mute Sticker* _Has Been Disabled_🔊"
else
return "`انجام شد!`\n🎭بیصدا کردن برچسب غیر فعال شد🔊"
end 
end
end
---------------Mute Contact-------------------
local function mute_contact(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "❗️_You're Not_ *Moderator*❗️"
else
 return "❗️شما مدیر گروه نمیباشید❗️"
end
end

local mute_contact = data[tostring(target)]["mutes"]["mute_contact"] 
if mute_contact == "yes" then
if not lang then
 return "`Error❢` \n📞*Mute Contact* _Is Already Enabled_🔇"
elseif lang then
 return "`اخطار❢`\n📞بیصدا کردن مخاطب فعال است🔇"
end
else
 data[tostring(target)]["mutes"]["mute_contact"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "`Done!` \n📞*Mute Contact* _Has Been Enabled_🔇"
else
 return "`انجام شد!`\n📞بیصدا کردن مخاطب فعال شد🔇"
end
end
end

local function unmute_contact(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "❗️_You're Not_ *Moderator*❗️"
else
return "❗️شما مدیر گروه نمیباشید❗️"
end
end 

local mute_contact = data[tostring(target)]["mutes"]["mute_contact"]
 if mute_contact == "no" then
if not lang then
return "`Error❢` \n📞*Mute Contact* _Is Already Disabled_🔊" 
elseif lang then
return "`اخطار❢`\n📞بیصدا کردن مخاطب غیر فعال است🔊"
end
else 
data[tostring(target)]["mutes"]["mute_contact"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "`Done!` \n📞*Mute Contact* _Has Been Disabled_🔊" 
else
return "`انجام شد!`\n📞بیصدا کردن مخاطب غیر فعال شد🔊"
end
end
end
---------------Mute Forward-------------------
local function mute_forward(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "❗️_You're Not_ *Moderator*❗️"
else
 return "❗️شما مدیر گروه نمیباشید❗️"
end
end

local mute_forward = data[tostring(target)]["mutes"]["mute_forward"] 
if mute_forward == "yes" then
if not lang then
 return "`Error❢` \n⏩*Mute Forward* _Is Already Enabled_🔇"
elseif lang then
 return "`اخطار❢`\n⏩بیصدا کردن نقل قول فعال است🔇"
end
else
 data[tostring(target)]["mutes"]["mute_forward"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "`Done!` \n⏩*Mute Forward* _Has Been Enabled_🔇"
else
 return "`انجام شد!`\n⏩بیصدا کردن نقل قول فعال شد🔇"
end
end
end

local function unmute_forward(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "❗️_You're Not_ *Moderator*❗️"
else
return "❗️شما مدیر گروه نمیباشید❗️"
end
end 

local mute_forward = data[tostring(target)]["mutes"]["mute_forward"]
 if mute_forward == "no" then
if not lang then
return "`Error❢` \n⏩*Mute Forward* _Is Already Disabled_🔊"
elseif lang then
return "`اخطار❢`\n⏩بیصدا کردن نقل قول غیر فعال است🔊"
end 
else 
data[tostring(target)]["mutes"]["mute_forward"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "`Done!` \n⏩*Mute Forward* _Has Been Disabled_🔊" 
else
return "`انجام شد!`\n⏩بیصدا کردن نقل قول غیر فعال شد🔊"
end
end
end
---------------Mute Location-------------------
local function mute_location(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "❗️_You're Not_ *Moderator*❗️"
else
 return "❗️شما مدیر گروه نمیباشید❗️"
end
end

local mute_location = data[tostring(target)]["mutes"]["mute_location"] 
if mute_location == "yes" then
if not lang then
 return "`Error❢` \n🔹*Mute Location* _Is Already Enabled_🔇"
elseif lang then
 return "`اخطار❢`\n🔹بیصدا کردن موقعیت فعال است🔇"
end
else
 data[tostring(target)]["mutes"]["mute_location"] = "yes" 
save_data(_config.moderation.data, data)
if not lang then
 return "`Done!` \n🔹*Mute Location* _Has Been Enabled_🔇"
else
 return "`انجام شد!`\n🔹بیصدا کردن موقعیت فعال شد🔇"
end
end
end

local function unmute_location(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "❗️_You're Not_ *Moderator*❗️"
else
return "❗️شما مدیر گروه نمیباشید❗️"
end
end 

local mute_location = data[tostring(target)]["mutes"]["mute_location"]
 if mute_location == "no" then
if not lang then
return "`Error❢` \n🔹*Mute Location* _Is Already Disabled_🔊" 
elseif lang then
return "`اخطار❢`\n🔹بیصدا کردن موقعیت غیر فعال است🔊"
end
else 
data[tostring(target)]["mutes"]["mute_location"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "`Done!` \n🔹*Mute Location* _Has Been Disabled_🔊" 
else
return "`انجام شد!`\n🔹بیصدا کردن موقعیت غیر فعال شد🔊"
end
end
end
---------------Mute Document-------------------
local function mute_document(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "❗️_You're Not_ *Moderator*❗️"
else
return "❗️شما مدیر گروه نمیباشید❗️"
end
end

local mute_document = data[tostring(target)]["mutes"]["mute_document"] 
if mute_document == "yes" then
if not lang then
 return "`Error❢` \n🗂*Mute Document* _Is Already Enabled_🔇"
elseif lang then
 return "`اخطار❢`\n🗂بیدا کردن اسناد فعال است🔇"
end
else
 data[tostring(target)]["mutes"]["mute_document"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "`Done!` \n🗂*Mute Document* _Has Been Enabled_🔇"
else
 return "`انجام شد!`\n🗂بیصدا کردن اسناد فعال شد🔇"
end
end
end

local function unmute_document(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "❗️_You're Not_ *Moderator*❗️"
else
return "❗️شما مدیر گروه نمیباشید❗️"
end
end 

local mute_document = data[tostring(target)]["mutes"]["mute_document"]
 if mute_document == "no" then
if not lang then
return "`Error❢` \n🗂*Mute Document* _Is Already Disabled_🔊" 
elseif lang then
return "`اخطار❢`\n🗂بیصدا کردن اسناد غیر فعال است🔊"
end
else 
data[tostring(target)]["mutes"]["mute_document"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "`Done!` \n🗂*Mute Document* _Has Been Disabled_🔊" 
else
return "`انجام شد!`\n🗂بیصدا کردن اسناد غیر فعال شد🔊"
end
end
end
---------------Mute TgService-------------------
local function mute_tgservice(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "❗️_You're Not_ *Moderator*❗️"
else
 return "❗️شما مدیر گروه نمیباشید❗️"
end
end

local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"] 
if mute_tgservice == "yes" then
if not lang then
 return "`Error❢` \n🔄*Mute TgService* _Is Already Enabled_🔇"
elseif lang then
 return "`اخطار❢`\n🔄بیصدا کردن خدمات تلگرام فعال است🔇"
end
else
 data[tostring(target)]["mutes"]["mute_tgservice"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "`Done!` \n🔄*Mute TgService* _Has Been Enabled_🔇"
else
return "`انجام شد!`\n🔄بیصدا کردن خدمات تلگرام فعال شد🔇"
end
end
end

local function unmute_tgservice(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "❗️_You're Not_ *Moderator❗️*"
else
return "❗️شما مدیر گروه نیستید❗️"
end 
end

local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"]
 if mute_tgservice == "no" then
if not lang then
return "`Error❢` \n🔄*Mute TgService* _Is Already Disabled_🔊"
elseif lang then
return "`اخطار❢`\n🔄بیصدا کردن خدمات تلگرام غیر فعال است🔊"
end 
else 
data[tostring(target)]["mutes"]["mute_tgservice"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "`Done!` \n🔄*Mute TgService* _Has Been Disabled_🔊"
else
return "`انجام شد!`\n🔄بیصدا کردن خدمات تلگرام غیر فعال شد🔊"
end 
end
end

---------------Mute Keyboard-------------------
local function mute_keyboard(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "❗️_You're Not_ *Moderator*❗️"
else
 return "❗️شما مدیر گروه نمیباشید❗️"
end
end

local mute_keyboard = data[tostring(target)]["mutes"]["mute_keyboard"] 
if mute_keyboard == "yes" then
if not lang then
 return "`Error❢` \n⌨*Mute Keyboard* _Is Already Enabled_🔇"
elseif lang then
 return "`اخطار❢`\n⌨بیصدا کردن صفحه کلید فعال است🔇"
end
else
 data[tostring(target)]["mutes"]["mute_keyboard"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "`Done!` \n⌨*Mute Keyboard* _Has Been Enabled_🔇"
else
return "`انجام شد!`\n⌨بیصدا کردن صفحه کلید فعال شد🔇"
end
end
end

local function unmute_keyboard(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "❗️_You're Not_ *Moderator*❗️"
else
return "❗️شما مدیر گروه نیستید❗️"
end 
end

local mute_keyboard = data[tostring(target)]["mutes"]["mute_keyboard"]
 if mute_keyboard == "no" then
if not lang then
return "`Error❢` \n⌨*Mute Keyboard* _Is Already Disabled_🔊"
elseif lang then
return "`اخطار❢`\n⌨بیصدا کردن صفحه کلید غیرفعال است🔊"
end 
else 
data[tostring(target)]["mutes"]["mute_keyboard"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "`Done!` \n⌨*Mute Keyboard* _Has Been Disabled_🔊"
else
return "`انجام شد!`\n⌨بیصدا کردن صفحه کلید غیرفعال شد🔊"
end 
end
end
----------MuteList---------
local function mutes(msg, target) 	
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 	return "❗️_You're Not_ *Moderator*❗️"	
else
 return "❗️شما مدیر گروه نیستید❗️"
end
end
local data = load_data(_config.moderation.data)
local target = msg.to.id 
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_all"] then			
data[tostring(target)]["mutes"]["mute_all"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_gif"] then			
data[tostring(target)]["mutes"]["mute_gif"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_text"] then			
data[tostring(target)]["mutes"]["mute_text"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_photo"] then			
data[tostring(target)]["mutes"]["mute_photo"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_video"] then			
data[tostring(target)]["mutes"]["mute_video"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_audio"] then			
data[tostring(target)]["mutes"]["mute_audio"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_voice"] then			
data[tostring(target)]["mutes"]["mute_voice"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_sticker"] then			
data[tostring(target)]["mutes"]["mute_sticker"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_contact"] then			
data[tostring(target)]["mutes"]["mute_contact"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_forward"] then			
data[tostring(target)]["mutes"]["mute_forward"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_location"] then			
data[tostring(target)]["mutes"]["mute_location"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_document"] then			
data[tostring(target)]["mutes"]["mute_document"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_tgservice"] then			
data[tostring(target)]["mutes"]["mute_tgservice"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_inline"] then			
data[tostring(target)]["mutes"]["mute_inline"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_game"] then			
data[tostring(target)]["mutes"]["mute_game"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_keyboard"] then			
data[tostring(target)]["mutes"]["mute_keyboard"] = "no"		
end
end
if not lang then
local mutes = data[tostring(target)]["mutes"] 
 text = " *Group Mute List* : \n\n`【`*Mute all*`】`*➤* `"..mutes.mute_all.."`\n`【`*Mute gif*`】`*➤* `"..mutes.mute_gif.."`\n`【`*Mute text*`】`*➤* `"..mutes.mute_text.."`\n`【`*Mute inline*`】`*➤* `"..mutes.mute_inline.."`\n`【`*Mute game*`】`*➤* `"..mutes.mute_game.."`\n`【`*Mute photo*`】`*➤* `"..mutes.mute_photo.."`\n`【`*Mute video*`】`*➤* `"..mutes.mute_video.."`\n`【`*Mute audio*`】`*➤* `"..mutes.mute_audio.."`\n`【`*Mute voice*`】`*➤* `"..mutes.mute_voice.."`\n`【`*Mute sticker*`】`*➤* `"..mutes.mute_sticker.."`\n`【`*Mute contact*`】`*➤* `"..mutes.mute_contact.."`\n`【`*Mute forward*`】`*➤* `"..mutes.mute_forward.."`\n`【`*Mute location*`】`*➤* `"..mutes.mute_location.."`\n`【`*Mute document*`】`*➤* `"..mutes.mute_document.."`\n`【`*Mute TgService*`】`*➤* `"..mutes.mute_tgservice.."`\n`【`*Mute Keyboard*`】`*➤* `"..mutes.mute_keyboard.."`\n*____________________*\n`₰`*Bot channel*`₰`: `:D`\n*➖➖➖➖➖➖➖➖➖*\n`⇈`*Group Language*`⇈` : *EN*\n*➖➖➖➖➖➖➖➖➖*\n`₰`*group name* `₰` :  `"..msg.to.title.."`\n`₰`*group id*`₰` : `"..chat.."` "
else
local mutes = data[tostring(target)]["mutes"] 
 text = "_لیست بیصدا ها_ : \n\n`【`_بیصدا همه_ `】` : `"..mutes.mute_all.."`\n`【`_بیصدا تصاویر متحرک_`】` : `"..mutes.mute_gif.."`\n`【`_بیصدا متن_`】` : `"..mutes.mute_text.."`\n`【`_بیصدا کیبورد شیشه ای_`】` : `"..mutes.mute_inline.."`\n`【`_بیصدا بازی های تحت وب_`】` : `"..mutes.mute_game.."`\n`【`_بیصدا عکس_`】` : `"..mutes.mute_photo.."`\n`【`_بیصدا فیلم_`】` : `"..mutes.mute_video.."`\n`【`_بیصدا آهنگ_`】` : `"..mutes.mute_audio.."`\n`【`_بیصدا صدا_`】` : `"..mutes.mute_voice.."`\n`【`_بیصدا برچسب_`】` : `"..mutes.mute_sticker.."`\n`【`_بیصدا مخاطب_`】` : `"..mutes.mute_contact.."`\n`【`_بیصدا نقل قول_`】` : `"..mutes.mute_forward.."`\n`【`_بیصدا موقعیت_`】` : `"..mutes.mute_location.."`\n`【`_بیصدا اسناد :_ *"..mutes.mute_document.."*\n`【`_بیصدا خدمات تلگرام_`】` : `"..mutes.mute_tgservice.."`\n`【`_بیصدا صفحه کلید_`】` : `"..mutes.mute_keyboard.."`\n*____________________*\n`₰`*Bot channel*`₰`: `:D`\n*➖➖➖➖➖➖➖➖➖*\n`⇈`_زبان سوپرگروه_`⇈` : *FA*\n*➖➖➖➖➖➖➖➖➖*\n `₰` _نام گروه_ `₰` : `"..msg.to.title.."`\n `₰` _آیدی گروه_ `₰` : `"..chat.."`"
end
return text
end
-- Returns the key (index) in the config.enabled_plugins table
local function plugin_enabled( name )
  for k,v in pairs(_config.enabled_plugins) do
    if name == v then
      return k
    end
  end
  -- If not found
  return false
end

-- Returns true if file exists in plugins folder
local function plugin_exists( name )
  for k,v in pairs(plugins_names()) do
    if name..'.lua' == v then
      return true
    end
  end
  return false
end

local function list_all_plugins(only_enabled)
  local tmp = '\n\n:D'
  local text = ''
  local nsum = 0
  for k, v in pairs( plugins_names( )) do
    --  ✔ enabled, ❌ disabled
    local status = '*|✖️|*>'
    nsum = nsum+1
    nact = 0
    -- Check if is enabled
    for k2, v2 in pairs(_config.enabled_plugins) do
      if v == v2..'.lua' then 
        status = '*|✔|>*'
      end
      nact = nact+1
    end
    if not only_enabled or status == '*|✔|>*'then
      -- get the name
      v = string.match (v, "(.*)%.lua")
      text = text..nsum..'.'..status..' '..v..' \n'
    end
  end
  local text = text..'\n\n'..nsum..' *📂plugins installed*\n\n'..nact..' _✔️plugins enabled_\n\n'..nsum-nact..' _❌plugins disabled_'..tmp
  return text
end

local function list_plugins(only_enabled)
  local text = ''
  local nsum = 0
  for k, v in pairs( plugins_names( )) do
    --  ✔ enabled, ❌ disabled
    local status = '*|✖️|>*'
    nsum = nsum+1
    nact = 0
    -- Check if is enabled
    for k2, v2 in pairs(_config.enabled_plugins) do
      if v == v2..'.lua' then 
        status = '*|✔|>*'
      end
      nact = nact+1
    end
    if not only_enabled or status == '*|✔|>*'then
      -- get the name
      v = string.match (v, "(.*)%.lua")
     -- text = text..v..'  '..status..'\n'
    end
  end
  local text = text.."\n_🔃All Plugins Reloaded_\n\n"..nact.." *✔️Plugins Enabled*\n"..nsum.." *📂Plugins Installed*\n\n:D"
return text
end

local function reload_plugins( )
  plugins = {}
  load_plugins()
  return list_plugins(true)
end


local function enable_plugin( plugin_name )
  print('checking if '..plugin_name..' exists')
  -- Check if plugin is enabled
  if plugin_enabled(plugin_name) then
    return ''..plugin_name..' _is enabled_'
  end
  -- Checks if plugin exists
  if plugin_exists(plugin_name) then
    -- Add to the config table
    table.insert(_config.enabled_plugins, plugin_name)
    print(plugin_name..' added to _config table')
    save_config()
    -- Reload the plugins
    return reload_plugins( )
  else
    return ''..plugin_name..' _does not exists_'
  end
end

local function disable_plugin( name, chat )
  -- Check if plugins exists
  if not plugin_exists(name) then
    return ' '..name..' _does not exists_'
  end
  local k = plugin_enabled(name)
  -- Check if plugin is enabled
  if not k then
    return ' '..name..' _not enabled_'
  end
  -- Disable and reload
  table.remove(_config.enabled_plugins, k)
  save_config( )
  return reload_plugins(true)    
end

local function disable_plugin_on_chat(receiver, plugin)
  if not plugin_exists(plugin) then
    return "_Plugin doesn't exists_"
  end

  if not _config.disabled_plugin_on_chat then
    _config.disabled_plugin_on_chat = {}
  end

  if not _config.disabled_plugin_on_chat[receiver] then
    _config.disabled_plugin_on_chat[receiver] = {}
  end

  _config.disabled_plugin_on_chat[receiver][plugin] = true

  save_config()
  return ' '..plugin..' _disabled on this chat_'
end

local function reenable_plugin_on_chat(receiver, plugin)
  if not _config.disabled_plugin_on_chat then
    return 'There aren\'t any disabled plugins'
  end

  if not _config.disabled_plugin_on_chat[receiver] then
    return 'There aren\'t any disabled plugins for this chat'
  end

  if not _config.disabled_plugin_on_chat[receiver][plugin] then
    return '_This plugin is not disabled_'
  end

  _config.disabled_plugin_on_chat[receiver][plugin] = false
  save_config()
  return ' '..plugin..' is enabled again'
end

local function run(msg, matches)
if matches[1] == "gban" and is_admin(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="gban"})
end
  if matches[2] and string.match(matches[2], '^%d+$') then
   if is_admin1(matches[2]) then
   if not lang then
    return tdcli.sendMessage(msg.to.id, "", 0, "*Error❢*\nYou can't *globally ban*\n `【✶Mods,✷Owners & ❈BotAdmins】`", 0, "md")
else
    return tdcli.sendMessage(msg.to.id, "", 0, "_اخطار❢_\n_شما نمیتوانید  افراد ذیل شده را ازتمام گروه های ربات محروم کنید_\n`【✶مدیران,✷اونر ها & ❈ادمین های ربات】`", 0, "md")
        end
     end
   if is_gbanned(matches[2]) then
   if not lang then
  return tdcli.sendMessage(msg.to.id, "", 0, "*Error❢*\n`User is Already globally bannded`\n*User info:*\n_User Id:_ *[ "..matches[2].." ]*", 0, "md")
    else
  return tdcli.sendMessage(msg.to.id, "", 0, "_خطا❢_\n`کاربر از گروه های برات محروم بود`\n`اطلاعات کاربر:`\n _آیدی:_ *[ "..matches[2].." ]*", 0, "md")
        end
     end
  data['gban_users'][tostring(matches[2])] = ""
    save_data(_config.moderation.data, data)
kick_user(matches[2], msg.to.id)
   if not lang then
 return tdcli.sendMessage(msg.to.id, msg.id, 0, "*Done!*\n`User has been Globally Baned`\n*User Info:*\n_User Id:_ *[ "..matches[2].." ]*", 0, "md")
    else
 return tdcli.sendMessage(msg.to.id, msg.id, 0, "_انجام شد!_\n`کاربرازتمام گروه های بات محروم شد`\n `اطلاعات کاربر:`\n_آیدی:_ *[ "..matches[2].." ]*", 0, "md")
      end
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="gban"})
      end
   end
 if matches[1] == "ungban" and is_admin(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="ungban"})
end
  if matches[2] and string.match(matches[2], '^%d+$') then
   if not is_gbanned(matches[2]) then
     if not lang then
   return tdcli.sendMessage(msg.to.id, "", 0, "*Error❢*\n`User is not globally banned`\n*User info:*\n_User Id:_ *[ "..matches[2].." ]*", 0, "md")
    else
   return tdcli.sendMessage(msg.to.id, "", 0, "_خطا❢_\n`کاربرازتمام گروه های ربات محروم نبود`\n`اطلاعات کاربر:`\n_آیدی:_ *[ "..matches[2].." ]*", 0, "md")
        end
     end
  data['gban_users'][tostring(matches[2])] = nil
    save_data(_config.moderation.data, data)
   if not lang then
return tdcli.sendMessage(msg.to.id, msg.id, 0, "*Done!*\n`User has been Globally unBaned`\n*User Info:*\n_User Id:_ *[ "..matches[2].." ]*", 0, "md")
   else
return tdcli.sendMessage(msg.to.id, msg.id, 0, "_انجام شد!_\n`کاربر از محرومیت گروه های ربات خارج شد`\n `اطلاعات کاربر:`\n_آیدی:_ *[ "..matches[2].." ]*", 0, "md")
      end
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="ungban"})
      end
   end
   if msg.to.type ~= 'pv' then
 if matches[1] == "ban" and is_mod(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="ban"})
end
  if matches[2] and string.match(matches[2], '^%d+$') then
   if is_mod1(msg.to.id, matches[2]) then
     if not lang then
    return tdcli.sendMessage(msg.to.id, "", 0, "*Error❢*\nYou can't*ban*\n`【✶Mods,✷Owners & ❈BotAdmins】`", 0, "md")
    else
    return tdcli.sendMessage(msg.to.id, "", 0, "_اخطار❢_\n_شما نمیتوانید افراد ذیل شده رااز گروه بن کنید_\n`【✶مدیران,✷اونر ها & ❈ادمین های ربات】`", 0, "md")
        end
     end
   if is_banned(matches[2], msg.to.id) then
   if not lang then
  return tdcli.sendMessage(msg.to.id, "", 0, "*Error❢*\n`User is Already Banned`\n*User info: *\n_User id :_ *[ "..matches[2].." ]*", 0, "md")
  else
  return tdcli.sendMessage(msg.to.id, "", 0, "_خطا❢_\n`کاربر از گروه محروم بود`\n`اطلاعات کاربر:`\n_آیدی:_ *[ "..matches[2].." ]*", 0, "md")
        end
     end
data[tostring(chat)]['banned'][tostring(matches[2])] = ""
    save_data(_config.moderation.data, data)
kick_user(matches[2], msg.to.id)
   if not lang then
 return tdcli.sendMessage(msg.to.id, msg.id, 0, "*Done!*\n`User Has been Baned`\n*User info:*\n_User id :_ *[ "..matches[2].." ]*", 0, "md")
  else
 return tdcli.sendMessage(msg.to.id, msg.id, 0, "_انجام شد!_ \n`کاربر از گروه محروم شد`\n `اطلاعات کاربر:`\n_ایدی:_ *[ "..matches[2].." ]*", 0, "md")
      end
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
     tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="ban"})
      end
   end
 if matches[1] == "unban" and is_mod(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="unban"})
end
  if matches[2] and string.match(matches[2], '^%d+$') then
   if not is_banned(matches[2], msg.to.id) then
   if not lang then
   return tdcli.sendMessage(msg.to.id, "", 0, "*Error❢*\n`User is not Bannded`\n*User Info:*\n_User Id:_ *[ "..matches[2].." ]*", 0, "md")
  else
   return tdcli.sendMessage(msg.to.id, "", 0, "_خطا❢_\n`کاربر از گروه محروم نبود`\n`اطلاعات کاربر:`\n_آیدی:_ *[ "..matches[2].." ]*", 0, "md")
        end
     end
data[tostring(chat)]['banned'][tostring(matches[2])] = nil
    save_data(_config.moderation.data, data)
   if not lang then
return tdcli.sendMessage(msg.to.id, msg.id, 0, "*Done!*\n`User has been Unbanned`\n*User Info:*\n_User Id:_ *[ "..matches[2].." ]*", 0, "md")
   else
return tdcli.sendMessage(msg.to.id, msg.id, 0, "_انجام شد!_ \n`کاربرازمحرومیت گروه خارج شد`\n `اطلاعات کاربر:`\n_آیدی:_ *[ "..matches[2].." ]*", 0, "md")
      end
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="unban"})
      end
   end
 if matches[1] == "silentuser" and is_mod(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="silentuser"})
end
  if matches[2] and string.match(matches[2], '^%d+$') then
   if is_mod1(msg.to.id, matches[2]) then
   if not lang then
   return tdcli.sendMessage(msg.to.id, "", 0, "*Error❢*\nYou can't *Silent*:\n`【✶Mods,✷Owners & ❈BotAdmins】`", 0, "md")
 else
   return tdcli.sendMessage(msg.to.id, "", 0, "_اخطار❢_\n_شما نمیتوانید افراد ذیل شده را سایلنت کنید:_\n`【✶مدیران,✷اونر ها & ❈ادمین های ربات】`", 0, "md")
        end
     end
   if is_silent_user(matches[2], chat) then
   if not lang then
   return tdcli.sendMessage(msg.to.id, "", 0, "*Error❢*\n`User is Already Silent`\n*User info:* \n_User Id:_ *[ "..matches[2].." ]*", 0, "md")
   else
   return tdcli.sendMessage(msg.to.id, "", 0, "_خطا❢_\n`کاربراز قبل سایلنت بود`\n`اطلاعات کاربر:`\n _آیدی:_ *[ "..matches[2].." ]*", 0, "md")
        end
     end
data[tostring(chat)]['is_silent_users'][tostring(matches[2])] = ""
    save_data(_config.moderation.data, data)
    if not lang then
 return tdcli.sendMessage(msg.to.id, msg.id, 0, "*Done!*\n`User Added to Silent list`\n*User Info:*\n_User Id:_ *[ "..matches[2].." ]*", 0, "md")
  else
 return tdcli.sendMessage(msg.to.id, msg.id, 0, "_انجام شد!_\n`کاربر توانایی چت کردن رو از دست داد`\n `اطلاعات کاربر:`\n _آیدی:_ *[ "..matches[2].." ]*", 0, "md")
      end
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="silentuser"})
      end
   end
 if matches[1] == "unsilentuser" and is_mod(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="unsilentuser"})
end
  if matches[2] and string.match(matches[2], '^%d+$') then
   if not is_silent_user(matches[2], chat) then
     if not lang then
     return tdcli.sendMessage(msg.to.id, "", 0, "*Error❢*\n`User is not silent`\nuser: "..matches[2].."", 0, "md")
   else
     return tdcli.sendMessage(msg.to.id, "", 0, "_خطا❢_\n`کاربر از قبل توانایی چت کردن رو داشت`\n `اطلاعات کاربر:`\n _آیدی:_ *[ "..matches[2].." ]*", 0, "md")
        end
     end
data[tostring(chat)]['is_silent_users'][tostring(matches[2])] = nil
    save_data(_config.moderation.data, data)
   if not lang then
 return tdcli.sendMessage(msg.to.id, msg.id, 0, "*Done!*\n`User removed from silent users list`\nuser: *"..matches[2].."*", 0, "md")
  else
 return tdcli.sendMessage(msg.to.id, msg.id, 0, "_انجام شد!_\n `کاربر توانایی چت کردن را بدست آورد`\n_آیدی:_ *"..matches[2].."*", 0, "md")
      end
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="unsilentuser"})
      end
   end
		if matches[1]:lower() == 'delete' and is_owner(msg) then
			if matches[2] == 'bans' then
				if next(data[tostring(chat)]['banned']) == nil then
     if not lang then
					return "*Error❢*\n`No banned users in this group`"
   else
					return "_خطا _\n`هیچ کاربری از این گروه محروم نشده`"
              end
				end
				for k,v in pairs(data[tostring(chat)]['banned']) do
					data[tostring(chat)]['banned'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
     if not lang then
				return "*Done!*\n `All banned users has been unbanned`"
    else
				return "_انجام شد\n `تمام کاربران محروم شده از گروه از محرومیت خارج شدند.`"
           end
			end
			if matches[2] == 'silentlist' then
				if next(data[tostring(chat)]['is_silent_users']) == nil then
        if not lang then
					return "*Error❢*\n`No silent users in this group`"
   else
					return "_خطا_\n `لیست کاربران سایلنت شده خالی است`"
             end
				end
				for k,v in pairs(data[tostring(chat)]['is_silent_users']) do
					data[tostring(chat)]['is_silent_users'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				    end
       if not lang then
				return "*Done!*\n `Silent list has been cleaned`"
   else
				return "_انجام شد!_\n `تمام کاربران سایلنت شده پاک شدند`"
               end
			    end
        end
     end
		if matches[1]:lower() == 'delete' and is_sudo(msg) then
			if matches[2] == 'gbans' then
				if next(data['gban_users']) == nil then
    if not lang then
					return "*Error❢*\n`No globally banned users available`"
   else
					return "_خطا _\n `هیچ کاربری که از گروه های ربات محروم شده است وجودندارد`"
             end
				end
				for k,v in pairs(data['gban_users']) do
					data['gban_users'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
      if not lang then
				return "*Done!*\n `All globally banned has been unbanned`"
   else
				return "_انجام شد\n `تمام کاربران بن شده از گپ های ربات از بن گولبال خارج شدند`"
          end
			end
     end
if matches[1] == "gbanlist" and is_admin(msg) then
  return gbanned_list(msg)
 end
   if msg.to.type ~= 'pv' then
if matches[1] == "silentlist" and is_mod(msg) then
  return silent_users_list(chat)
 end
if matches[1] == "banlist" and is_mod(msg) then
  return banned_list(chat)
     end
  end
  if matches[1]:lower() == 'id' then
		function get_id(arg, data)
			local username
			if data.first_name_ then
				if data.username_ then
					username = '@'..data.username_
				else
					username = '<i>No Username!</i>'
				end
				local telNum
				if data.phone_number_ then
					telNum = '+'..data.phone_number_
				else
					telNum = '----'
				end
				local lastName
				if data.last_name_ then
					lastName = data.last_name_
				else
					lastName = '----'
				end
				local rank
				if is_sudo(msg) then
					rank = 'Sudo'
				elseif is_owner(msg) then
					rank = 'Bot Owner'
				elseif is_admin(msg) then
					rank = 'Admin'
				elseif is_mod(msg) then
					rank = 'Moderator'
				else
					rank = 'Group Member'
				end
				local text = '<b>First Name:</b> <i>'..data.first_name_..'</i>\n<b>Username:</b> '..username..'\n<b>ID:</b> [ <code>'..data.id_..'</code> ]\n<b>Group ID:</b> [ <code>'..arg.chat_id..'</code> ]\n<b>Your link</b>:\nhttps://telegram.me/'..data.username_..''
				tdcli.sendMessage(arg.chat_id, msg.id_, 1, text, 0, 'html')
			end
		end
		tdcli_function({ ID = 'GetUser', user_id_ = msg.sender_user_id_, }, get_id, {chat_id=msg.chat_id_, user_id=msg.sendr_user_id_})
	end
	if matches[1]:lower() == 'info' then
		function get_id(arg, data)
			local username
			if data.first_name_ then
				if data.username_ then
					username = '@'..data.username_
				else
					username = '<i>No Username!</i>'
				end
				local telNum
				if data.phone_number_ then
					telNum = '+'..data.phone_number_
				else
					telNum = '----'
				end
				local lastName
				if data.last_name_ then
					lastName = data.last_name_
				else
					lastName = '----'
				end
				local rank
				if is_sudo(msg) then
					rank = 'Sudo'
				elseif is_owner(msg) then
					rank = 'Bot Owner'
				elseif is_admin(msg) then
					rank = 'Admin'
				elseif is_mod(msg) then
					rank = 'Moderator'
				else
					rank = 'Group Member'
				end
				local text = '<i>Information:</i>\n\n<b>First Name:</b> <code>'..data.first_name_..'</code>\n\n<b>Last Name:</b> <code>'..lastName..'</code>\n\n<b>Username:</b> '..username..'\n\n<b>ID:</b> <code>[ '..data.id_..' ]</code>\n\n<b>Phone Number:</b>  <b>'..telNum..'</b>'
				local user_info = {} 
  local uhash = 'user:'..data.id_
  local user = redis:hgetall(uhash)
  local um_hash = 'msgs:'..data.id_..':'..arg.chat_id
  user_info_msgs = tonumber(redis:get(um_hash) or 0)
   text = text..'\n\n<b>Total messages :</b> <code>'..user_info_msgs..'</code>'
   text = text..' \n\n<b>Rank:</b> <code>'..rank..'</code>\n\n<b>Group ID: </b> <code>'..arg.chat_id..'</code>'
				tdcli.sendMessage(arg.chat_id, msg.id_, 1, text, 1, 'html')
			end
		end
		tdcli_function({ ID = 'GetUser', user_id_ = msg.sender_user_id_, }, get_id, {chat_id=msg.chat_id_, user_id=msg.sendr_user_id_})
	end
	if matches[1] == "mypic" then
 local function dl_photo(arg,data) tdcli.sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, data.photos_[0].sizes_[1].photo_.persistent_id_,'【User id】 ➣ '..msg.sender_user_id_..'\n〰〰〰〰〰〰〰\n【Group id】 ➣ '..msg.chat_id_..'\n〰〰〰〰〰〰〰\n【Group Name】 ➣ '..msg.to.title..'' )
end
  tdcli_function ({ID =
"GetUserProfilePhotos",user_id_ =
msg.sender_user_id_,offset_ =
tonumber(matches[2]) - 1,limit_ = 100000}, dl_photo, nil)
end
if matches[1]:lower() == 'time' then
local url , res = http.request('http://api.gpmod.ir/time/')
if res ~= 200 then return "No connection" end
local jdat = json:decode(url)
local text = '_زمان به وقت ايران:_ `'..jdat.FAtime..'`\n_تاريخ به وقت ايران:_ `'..jdat.FAdate..'`\n➖➖➖➖➖➖➖➖➖\n*En Time:* _'..jdat.ENtime..'_\n *En Data:* _'..jdat.ENdate.. '_\n'
  tdcli.sendMessage (msg.chat_id_, 0, 1, text, 1, 'md')
end
    if matches[1] == 'del' then
    if msg.chat_id_:match("^-100") then
       if is_mod(msg) then
          if tonumber(matches[2]) > 100 or tonumber(matches[2]) < 1 then
             pm = '<b>Error!</b>\n<i>The number of messages can be deleted at any time from</i> <b>1</b> <i>to</i> <b>100</b>'
             tdcli.sendMessage(msg.chat_id_, msg.id_, 1, pm, 1, 'html')
             else
          tdcli_function ({
    ID = "GetChatHistory",
    chat_id_ = msg.chat_id_,
    from_message_id_ = 0,
    offset_ = 0,
    limit_ = tonumber(matches[2])
  }, delmsg, nil)
             pm ='<b>DONE!</b>\n <b>'..matches[2]..'</b> <i>massege has been cleaned</i>'
             tdcli.sendMessage(msg.chat_id_, msg.id_, 1, pm, 1, 'html')
         end
     end
 else pm ='<code>Error!</code>'
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, pm, 1, 'html')
end
end
local datebase = {
   "ربات سیکیور انلاین و اماده به کار است🍃",
  "*im online*",
  "_Online ;)_",
   "`ربات فعال است`",
   "*secure* _bot_ `is online ;)`",
   "*PoNg*",
  }
if matches[1] == 'online' then 
return datebase[math.random(#datebase)]
end
if matches[1] == 'ping' then 
return datebase[math.random(#datebase)]
end
if matches [1] =='setnerkh' then 
if not is_admin(msg) then 
return 'شما سودو نیستید' 
end 
local nerkh = matches[2] 
redis:set('bot:nerkh',nerkh) 
return '💾متن شما با موفقیت تنظیم شد.💾' 
end 
if matches[1] == 'nerkh' then 
if not is_mod(msg) then 
return 
end 
    local hash = ('bot:nerkh') 
    local nerkh = redis:get(hash) 
    if not nerkh then 
    return ' ⚠️ثبت نشده⚠️' 
    else 
     tdcli.sendMessage(msg.chat_id_, 0, 1, nerkh, 1, 'html') 
    end 
    end 
if matches[1] == 'نرخ' then
if not is_mod(msg) then 
return 
end 
    local hash = ('bot:nerkh') 
    local nerkh = redis:get(hash) 
    if not nerkh then 
    return ' ⚠️ثبت نشده⚠️' 
    else 
     tdcli.sendMessage(msg.chat_id_, 0, 1, nerkh, 1, 'html') 
    end 
    end 
if matches[1]=="delnerkh" then 
if not is_admin(msg) then 
return '‼️شما ادمین نیستید‼️' 
end 
    local hash = ('bot:nerkh') 
    redis:del(hash) 
return '🗑پاک شد🗑' 
end 
if matches[1] == 'cpu' then
  return text85
end
if matches[1]=="rank" and is_sudo(msg) then 
return  "`Your Rank `: *Sudo*"
end
if matches[1]=="rank" and is_admin(msg) then 
return  "`Your Rank `: *Admin* "
end
if matches[1]=="rank" and is_owner(msg) then 
return  "`Your Rank `: *Owner*"
end
if matches[1]=="rank" and is_mod(msg) then 
return  "`Your Rank` : *Moderator*"
end
if matches[1]=="rank" and not is_mod(msg) then
return  "`Your Rank` : *My dick*"
end
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
local data = load_data(_config.moderation.data)
local chat = msg.to.id
local user = msg.from.id
if msg.to.type ~= 'pv' then
if matches[1] == "userid" then
if not matches[2] and not msg.reply_id then
   if not lang then
return "📜*Chat ID :* _"..chat.."_\n👤*User ID :* _"..user.."_"
   else
return "📜*شناسه گروه :* _"..chat.."_\n👤*شناسه شما :* _"..user.."_"
   end
end
if msg.reply_id and not matches[2] then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="userid"})
  end
if matches[2] then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="userid"})
      end
   end
if matches[1] == "pin" and is_mod(msg) and msg.reply_id then
local lock_pin = data[tostring(msg.to.id)]["settings"]["lock_pin"] 
 if lock_pin == 'yes' then
if is_owner(msg) then
    data[tostring(chat)]['pin'] = msg.reply_id
	  save_data(_config.moderation.data, data)
tdcli.pinChannelMessage(msg.to.id, msg.reply_id, 1)
if not lang then
return "📌*Message Has Been Pinned*📌"
elseif lang then
return "📌پیام سجاق شد📌"
end
elseif not is_owner(msg) then
   return
 end
 elseif lock_pin == 'no' then
    data[tostring(chat)]['pin'] = msg.reply_id
	  save_data(_config.moderation.data, data)
tdcli.pinChannelMessage(msg.to.id, msg.reply_id, 1)
if not lang then
return "📌*Message Has Been Pinned*📌"
elseif lang then
return "📌پیام سجاق شد📌"
end
end
end
if matches[1] == 'unpin' and is_mod(msg) then
local lock_pin = data[tostring(msg.to.id)]["settings"]["lock_pin"] 
 if lock_pin == 'yes' then
if is_owner(msg) then
tdcli.unpinChannelMessage(msg.to.id)
if not lang then
return "❕*Pin message has been unpinned*❕"
elseif lang then
return "❕پیام سنجاق شده پاک شد❕"
end
elseif not is_owner(msg) then
   return 
 end
 elseif lock_pin == 'no' then
tdcli.unpinChannelMessage(msg.to.id)
if not lang then
return "❕*Pin message has been unpinned*❕"
elseif lang then
return "❕پیام سنجاق شده پاک شد❕"
end
end
end
if matches[1] == "add" then
return modadd(msg)
end
if matches[1] == "rem" then
return modrem(msg)
end
if matches[1] == "setowner" and is_admin(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="setowner"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="setowner"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="setowner"})
      end
   end
if matches[1] == "remowner" and is_admin(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="remowner"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="remowner"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="remowner"})
      end
   end
if matches[1] == "modset" and is_owner(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="modset"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="modset"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="modset"})
      end
   end
if matches[1] == "moddem" and is_owner(msg) then
if not matches[2] and msg.reply_id then
 tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="moddem"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="moddem"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="moddem"})
      end
   end
if matches[1] == "kick" and is_mod(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="kick"})
end
  if matches[2] and string.match(matches[2], '^%d+$') then
   if is_mod1(msg.to.id, matches[2]) then
   if not lang then
     tdcli.sendMessage(msg.to.id, "", 0, "*Error❢*\nYou can't *kick*\n`【✶Mods,✷Owners & ❈BotAdmins】`", 0, "md")
   elseif lang then
     tdcli.sendMessage(msg.to.id, "", 0, "_اخطار❢_\n_شما نمیتوانید افراد ذیل شده را اخراج کنید_\n`【✶مدیران,✷اونر ها & ❈ادمین های ربات】`", 0, "md")
         end
     else
kick_user(matches[2], msg.to.id)
      end
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="kick"})
         end
      end
 if matches[1] == "delall" and is_mod(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="delall"})
end
  if matches[2] and string.match(matches[2], '^%d+$') then
   if is_mod1(msg.to.id, matches[2]) then
   if not lang then
   return tdcli.sendMessage(msg.to.id, "", 0, "*Error❢*\nYou can't *delete chat*\n`【✶Mods,✷Owners & ❈BotAdmins】`", 0, "md")
     elseif lang then
   return tdcli.sendMessage(msg.to.id, "", 0, "_اخطار❢_\n_شما نمیتوانید پیام افراد ذیل شده را پاک کنید_\n`【✶مدیران,✷اونر ها & ❈ادمین های ربات】`", 0, "md")
   end
     else
tdcli.deleteMessagesFromUser(msg.to.id, matches[2], dl_cb, nil)
    if not lang then
  return tdcli.sendMessage(msg.to.id, "", 0, "*Done!*\n`All messages this User has been deleted`\n*User Info:*\n_User Id:_ *[ "..matches[2].." ]*", 0, "md")
   elseif lang then
  return tdcli.sendMessage(msg.to.id, "", 0, "_انجام شد!_\n`تمام پیام های این کاربر پاک شد`\n_آیدی:_ *[ "..matches[2].." ]*", 0, "md")
         end
      end
   end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="delall"})
         end
      end
   
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if tonumber(msg.from.id) == SUDO then
if matches[1] == "visudo" then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="visudo"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="visudo"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="visudo"})
      end
   end
if matches[1] == "desudo" then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="desudo"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="desudo"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="desudo"})
      end
   end
end
if matches[1] == "adminprom" and is_sudo(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="adminprom"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="adminprom"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="adminprom"})
      end
   end
if matches[1] == "admindem" and is_sudo(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.to.id,cmd="admindem"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="admindem"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="admindem"})
      end
   end
   
   if matches[1] == 'chats' and is_admin(msg) then
return chat_list(msg)
    end

if matches[1] == 'creategroup' and is_admin(msg) then
local text = matches[2]
tdcli.createNewGroupChat({[0] = msg.from.id}, text)
  if not lang then
return '⚒_Group Has Been Created!_⚒'
  else
return '⚒_گروه ساخته شد!_⚒'
   end
end

if matches[1] == 'createsuper' and is_admin(msg) then
local text = matches[2]
tdcli.createNewChannelChat({[0] = msg.sender_user_id_}, text)
   if not lang then 
return '⚒_SuperGroup Has Been Created!_⚒'
  else
return '⚒_سوپر گروه ساخته شد!_⚒'
   end
end

if matches[1] == 'tosuper' and is_admin(msg) then
local id = msg.to.id
tdcli.migrateGroupChatToChannelChat(id)
  if not lang then
return '📜_Group Has Been Changed To SuperGroup!_♻️'
  else
return '📜_گروه به سوپر گروه تبدیل شد!_♻️'
   end
end

if matches[1] == 'import' and is_admin(msg) then
tdcli.importChatInviteLink(matches[2])
   if not lang then
return '📥*Done!*📥'
  else
return '📥*انجام شد!*📥'
  end
end

if matches[1] == 'setbotname' and is_sudo(msg) then
tdcli.changeName(matches[2])
   if not lang then
return '》_Bot Name Changed To🤖:_ *'..matches[2]..'*'
  else
return '》_اسم ربات تغییر کرد به🤖:_ \n*'..matches[2]..'*'
   end
end

if matches[1] == 'setbotusername' and is_sudo(msg) then
tdcli.changeUsername(matches[2])
   if not lang then
return '》_Bot Username Changed To🤖:_ @'..matches[2]
  else
return '》_یوزرنیم ربات تغییر کرد به🤖:_ \n@'..matches[2]..''
   end
end

if matches[1] == 'delbotusername' and is_sudo(msg) then
tdcli.changeUsername('')
   if not lang then
return '🗑*Done!*🗑'
  else
return '🗑*انجام شد!*🗑'
  end
end

if matches[1] == 'markread' and is_sudo(msg) then
if matches[2] == 'on' then
redis:set('markread','on')
   if not lang then
return '》_Markread >_ *ON*✔️'
else
return '》_تیک دوم >_ *روشن*✔️'
   end
end
if matches[2] == 'off' then
redis:set('markread','off')
  if not lang then
return '》_Markread >_ *OFF*✔️'
   else
return '》_تیک دوم >_ *خاموش*✔️'
      end
   end
end

if matches[1] == 'bc' and is_admin(msg) then		
tdcli.sendMessage(matches[2], 0, 0, matches[3], 0)	
end	

if matches[1] == 'broadcast' and is_sudo(msg) then		
local data = load_data(_config.moderation.data)		
local bc = matches[2]			
for k,v in pairs(data) do				
tdcli.sendMessage(k, 0, 0, bc, 0)			
end	
end

if matches[1] == 'sudolist' and is_sudo(msg) then
return sudolist(msg)
    end

   if matches[1]:lower() == 'join' and is_admin(msg) and matches[2] then
	   tdcli.sendMessage(msg.to.id, msg.id, 1, 'I Invite you in '..matches[2]..'', 1, 'html')
	   tdcli.sendMessage(matches[2], 0, 1, "Admin Joined!🌚", 1, 'html')
    tdcli.addChatMember(matches[2], msg.from.id, 0, dl_cb, nil)
  end
		if matches[1] == 'rem' and matches[2] and is_admin(msg) then
    local data = load_data(_config.moderation.data)
			-- Group configuration removal
			data[tostring(matches[2])] = nil
			save_data(_config.moderation.data, data)
			local groups = 'groups'
			if not data[tostring(groups)] then
				data[tostring(groups)] = nil
				save_data(_config.moderation.data, data)
			end
			data[tostring(groups)][tostring(matches[2])] = nil
			save_data(_config.moderation.data, data)
	   tdcli.sendMessage(matches[2], 0, 1, "Group has been removed by admin command", 1, 'html')
    return '_Group_ *'..matches[2]..'* _removed_'
		end
if matches[1] == 'secure' then
return tdcli.sendMessage(msg.to.id, msg.id, 1, _config.info_text, 1, 'html')
    end
if matches[1] == 'adminlist' and is_admin(msg) then
return adminlist(msg)
    end
     if matches[1] == 'leave' and is_admin(msg) then
  tdcli.changeChatMemberStatus(msg.to.id, our_id, 'Left', dl_cb, nil)
   end
     if matches[1] == 'autoleave' and is_admin(msg) then
local hash = 'auto_leave_bot'
--Enable Auto Leave
     if matches[2] == 'enable' then
    redis:del(hash)
   return 'Auto leave has been enabled'
--Disable Auto Leave
     elseif matches[2] == 'disable' then
    redis:set(hash, true)
   return 'Auto leave has been disabled'
--Auto Leave Status
      elseif matches[2] == 'status' then
      if not redis:get(hash) then
   return 'Auto leave is enable'
       else
   return 'Auto leave is disable'
         end
      end
   end
-- Show the available plugins 
  if is_sudo(msg) then
  if matches[1]:lower() == '!plist' or matches[1]:lower() == '/plist' or matches[1]:lower() == '#plist' then --after changed to moderator mode, set only sudo
    return list_all_plugins()
  end
end
  -- Re-enable a plugin for this chat
   if matches[1] == 'pl' then
  if matches[2] == '+' and matches[4] == 'chat' then
      if is_momod(msg) then
    local receiver = msg.chat_id_
    local plugin = matches[3]
    print("enable "..plugin..' on this chat')
    return reenable_plugin_on_chat(receiver, plugin)
  end
    end

  -- Enable a plugin
  if matches[2] == '+' and is_sudo(msg) then --after changed to moderator mode, set only sudo
      if is_mod(msg) then
    local plugin_name = matches[3]
    print("enable: "..matches[3])
    return enable_plugin(plugin_name)
  end
    end
  -- Disable a plugin on a chat
  if matches[2] == '-' and matches[4] == 'chat' then
      if is_mod(msg) then
    local plugin = matches[3]
    local receiver = msg.chat_id_
    print("disable "..plugin..' on this chat')
    return disable_plugin_on_chat(receiver, plugin)
  end
    end
  -- Disable a plugin
  if matches[2] == '-' and is_sudo(msg) then --after changed to moderator mode, set only sudo
    if matches[3] == 'plugins' then
    	return 'This plugin can\'t be disabled'
    end
    print("disable: "..matches[3])
    return disable_plugin(matches[3])
  end
end
  -- Reload all the plugins!
  if matches[1] == '*' and is_sudo(msg) then --after changed to moderator mode, set only sudo
    return reload_plugins(true)
  end
  if matches[1]:lower() == 'reload' and is_sudo(msg) then --after changed to moderator mode, set only sudo
    return reload_plugins(true)
  end

	
if matches[1] == "welcome" and is_mod(msg) then
		if matches[2] == "enable" then
			welcome = data[tostring(chat)]['settings']['welcome']
			if welcome == "yes" then
       if not lang then
				return "💠_Group_ *welcome* _is already enabled_💠"
       elseif lang then
				return "💠_خوشآمد گویی از قبل فعال بود_💠"
           end
			else
		data[tostring(chat)]['settings']['welcome'] = "yes"
	    save_data(_config.moderation.data, data)
       if not lang then
				return "💠_Group_ *welcome* _has been enabled_💠"
       elseif lang then
				return "💠_خوشآمد گویی فعال شد_💠"
          end
			end
		end
		
		if matches[2] == "disable" then
			welcome = data[tostring(chat)]['settings']['welcome']
			if welcome == "no" then
      if not lang then
				return "💠_Group_ *Welcome* _is already disabled_⭕️"
      elseif lang then
				return "💠_خوشآمد گویی از قبل فعال نبود_⭕️"
         end
			else
		data[tostring(chat)]['settings']['welcome'] = "no"
	    save_data(_config.moderation.data, data)
      if not lang then
				return "_Group_ *welcome* _has been disabled_⭕️"
      elseif lang then
				return "_خوشآمد گویی غیرفعال شد_⭕️"
          end
			end
		end
	end
	if matches[1] == "setwelcome" and matches[2] and is_mod(msg) then
		data[tostring(chat)]['setwelcome'] = matches[2]
	    save_data(_config.moderation.data, data)
       if not lang then
		return "💠_Welcome Message Has Been Set To💾 :_\n*"..matches[2].."*\n\n🔺*You can use :*\n🔅_{gpname} Group Name_\n🔹_{rules} ➣ Show Group Rules_\n🔸_{name} ➣ New Member First Name_\n🔻_{username} ➣ New Member Username_"
       else
		return "💠_پیام خوشآمد گویی تنظیم شد به💾 :_\n*"..matches[2].."*\n\n*🔺شما میتوانید از*\n🔅_{gpname} نام گروه_\n🔹_{rules} ➣ نمایش قوانین گروه_\n🔸_{name} ➣ نام کاربر جدید_\n🔻_{username} ➣ نام کاربری کاربر جدید_\n_استفاده کنید_"
        end
     end
	 if matches[1] == "gpinfo" and is_mod(msg) and msg.to.type == "channel" then
local function group_info(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
if not lang then
ginfo = "⚜*Group Info :*\n👤_Admin Count :_ *"..data.administrator_count_.."*\n👥_Member Count :_ *"..data.member_count_.."*\n❌_Kicked Count :_ *"..data.kicked_count_.."*\n🆔_Group ID :_ *"..data.channel_.id_.."*"
print(serpent.block(data))
elseif lang then
ginfo = "⚜*اطلاعات گروه :*\n👤_تعداد مدیران :_ *"..data.administrator_count_.."*\n👥_تعداد اعضا :_ *"..data.member_count_.."*\n❌_تعداد اعضای حذف شده :_ *"..data.kicked_count_.."*\n🆔_شناسه گروه :_ *"..data.channel_.id_.."*"
print(serpent.block(data))
end
        tdcli.sendMessage(arg.chat_id, arg.msg_id, 1, ginfo, 1, 'md')
end
 tdcli.getChannelFull(msg.to.id, group_info, {chat_id=msg.to.id,msg_id=msg.id})
end
if matches[1] == 'newlink' and is_mod(msg) then
			local function callback_link (arg, data)
   local hash = "gp_lang:"..msg.to.id
   local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data) 
				if not data.invite_link_ then
					administration[tostring(msg.to.id)]['settings']['linkgp'] = nil
					save_data(_config.moderation.data, administration)
       if not lang then
       return tdcli.sendMessage(msg.to.id, msg.id, 1, "❗️_Bot is not group creator_\n_set a link for group with using_ /setlink❗️", 1, 'md')
       elseif lang then
       return tdcli.sendMessage(msg.to.id, msg.id, 1, "❗️_ربات سازنده گروه نیست_\n_با دستور_ setlink/ _لینک جدیدی برای گروه ثبت کنید_❗️", 1, 'md')
    end
				else
					administration[tostring(msg.to.id)]['settings']['linkgp'] = data.invite_link_
					save_data(_config.moderation.data, administration)
        if not lang then
       return tdcli.sendMessage(msg.to.id, msg.id, 1, "📜*Newlink Created*♻️", 1, 'md')
        elseif lang then
       return tdcli.sendMessage(msg.to.id, msg.id, 1, "📜_لینک جدید ساخته شد_♻️", 1, 'md')
            end
				end
			end
 tdcli.exportChatInviteLink(msg.to.id, callback_link, nil)
		end
		if matches[1] == 'setlink' and is_owner(msg) then
			data[tostring(chat)]['settings']['linkgp'] = 'waiting'
			save_data(_config.moderation.data, data)
      if not lang then
			return '📜_Please send the new group_ *link* _now_📜'
    else 
         return '📜لطفا لینک گروه خود را ارسال کنید📜'
       end
		end

		if msg.text then
   local is_link = msg.text:match("^([https?://w]*.?telegram.me/joinchat/%S+)$") or msg.text:match("^([https?://w]*.?t.me/joinchat/%S+)$")
			if is_link and data[tostring(chat)]['settings']['linkgp'] == 'waiting' and is_owner(msg) then
				data[tostring(chat)]['settings']['linkgp'] = msg.text
				save_data(_config.moderation.data, data)
            if not lang then
				return "♻️*Newlink* _has been set_💾"
           else
           return "♻️لینک جدید ذخیره شد💾"
		 	end
       end
		end
    if matches[1] == 'link' and is_mod(msg) then
      local linkgp = data[tostring(chat)]['settings']['linkgp']
      if not linkgp then
      if not lang then
        return "❗️_First create a link for group with using_ /newlink\n_If bot not group creator set a link with using_ /setlink❗️"
     else
        return "❗️ابتدا با دستور newlink/ لینک جدیدی برای گروه بسازید\nو اگر ربات سازنده گروه نیس با دستور setlink/ لینک جدیدی برای گروه ثبت کنید❗️"
      end
      end
     if not lang then
       text = "🔱<b>Group Link🔱 :</b>\n"..linkgp
     else
      text = "🔱<b>لینک گروه 🔱:</b>\n"..linkgp
         end
        return tdcli.sendMessage(chat, msg.id, 1, text, 1, 'html')
     end
  if matches[1] == "setrules" and matches[2] and is_mod(msg) then
    data[tostring(chat)]['rules'] = matches[2]
	  save_data(_config.moderation.data, data)
     if not lang then
    return "⚖*Group rules* _has been set_⚖"
   else 
  return "⚖قوانین گروه ثبت شد⚖"
   end
  end
  if matches[1] == "rules" then
 if not data[tostring(chat)]['rules'] then
   if not lang then
     rules = "ℹ️ The Default Rules :\n1⃣ No Flood.\n2⃣ No Spam.\n3⃣ No Advertising.\n4⃣ Try to stay on topic.\n5⃣ Forbidden any racist, sexual, homophobic or gore content.\n➡️ Repeated failure to comply with these rules will cause ban.\n"
    elseif lang then
       rules = "ℹ️ قوانین پپیشفرض:\n1⃣ ارسال پیام مکرر ممنوع.\n2⃣ اسپم ممنوع.\n3⃣ تبلیغ ممنوع.\n4⃣ سعی کنید از موضوع خارج نشید.\n5⃣ هرنوع نژاد پرستی, شاخ بازی و پورنوگرافی ممنوع .\n➡️ از قوانین پیروی کنید, در صورت عدم رعایت قوانین اول اخطار و در صورت تکرار مسدود.\n"
 end
        else
     rules = "📜*Group Rules 📜:*\n"..data[tostring(chat)]['rules']
      end
    return rules
  end
if matches[1] == "res" and matches[2] and is_mod(msg) then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="res"})
  end
if matches[1] == "whois" and matches[2] and is_mod(msg) then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="whois"})
  end
  if matches[1] == 'floodmax' and is_mod(msg) then
			if tonumber(matches[2]) < 1 or tonumber(matches[2]) > 200 then
				return "❗️_Wrong number, range is_ *[1-200]*❗️"
      end
			local flood_max = matches[2]
			data[tostring(chat)]['settings']['num_msg_max'] = flood_max
			save_data(_config.moderation.data, data)
    return "📛_Group_ *flood* _sensitivity has been set to📛 :_ *[ "..matches[2].." ]*"
       end
		if matches[1]:lower() == 'delete' and is_owner(msg) then
			if matches[2] == 'mods' then
				if next(data[tostring(chat)]['mods']) == nil then
            if not lang then
					return "》_No_ *moderators* _in this group_👤"
             else
                return "》هیچ مدیری برای گروه انتخاب نشده است👤"
				end
            end
				for k,v in pairs(data[tostring(chat)]['mods']) do
					data[tostring(chat)]['mods'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
            if not lang then
				return "💢_All_ *moderators* _has been demoted_👤"
          else
            return "💢تمام مدیران گروه تنزیل مقام شدند👤"
			end
         end
			if matches[2] == 'filterlist' then
				if next(data[tostring(chat)]['filterlist']) == nil then
     if not lang then
					return "📋*Filtered words list* _is empty_🗑"
         else
					return "📋_لیست کلمات فیلتر شده خالی است_🗑"
             end
				end
				for k,v in pairs(data[tostring(chat)]['filterlist']) do
					data[tostring(chat)]['filterlist'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
       if not lang then
				return "🗑*Filtered words list* _has been cleaned_🗑"
           else
				return "🗑_لیست کلمات فیلتر شده پاک شد_🗑"
           end
			end
			if matches[2] == 'rules' then
				if not data[tostring(chat)]['rules'] then
            if not lang then
					return "❗️_No_ *rules* _available_❗️"
             else
               return "❗️قوانین برای گروه ثبت نشده است❗️"
             end
				end
					data[tostring(chat)]['rules'] = nil
					save_data(_config.moderation.data, data)
             if not lang then
				return "🗑*Group rules* _has been cleaned_🗑"
          else
            return "🗑قوانین گروه پاک شد🗑"
			end
       end
			if matches[2] == 'welcome' then
				if not data[tostring(chat)]['setwelcome'] then
            if not lang then
					return "💠*Welcome Message not set*❗️"
             else
               return "💠پیام خوشآمد گویی ثبت نشده است❗️"
             end
				end
					data[tostring(chat)]['setwelcome'] = nil
					save_data(_config.moderation.data, data)
             if not lang then
				return "🗑*Welcome message* _has been cleaned_🗑"
          else
            return "🗑پیام خوشآمد گویی پاک شد🗑"
			end
       end
			if matches[2] == 'about' then
        if msg.to.type == "chat" then
				if not data[tostring(chat)]['about'] then
            if not lang then
					return "⚠️_No_ *description* _available_⚠️"
            else
              return "⚠️پیامی مبنی بر درباره گروه ثبت نشده است⚠️"
          end
				end
					data[tostring(chat)]['about'] = nil
					save_data(_config.moderation.data, data)
        elseif msg.to.type == "channel" then
   tdcli.changeChannelAbout(chat, "", dl_cb, nil)
             end
             if not lang then
				return "🗑*Group description* _has been cleaned_🗑"
           else
              return "🗑پیام مبنی بر درباره گروه پاک شد🗑"
             end
		   	end
        end
		if matches[1]:lower() == 'delete' and is_admin(msg) then
			if matches[2] == 'owners' then
				if next(data[tostring(chat)]['owners']) == nil then
             if not lang then
					return "》_No_ *owners* _in this group_👤"
            else
                return "》مالکی برای گروه انتخاب نشده است👤"
            end
				end
				for k,v in pairs(data[tostring(chat)]['owners']) do
					data[tostring(chat)]['owners'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
            if not lang then
				return "👤_All_ *owners* _has been demoted_🗑"
           else
            return "👤تمامی مالکان گروه تنزیل مقام شدند🗑"
          end
			end
     end
if matches[1] == "setname" and matches[2] and is_mod(msg) then
local gp_name = matches[2]
tdcli.changeChatTitle(chat, gp_name, dl_cb, nil)
end
  if matches[1] == "setabout" and matches[2] and is_mod(msg) then
     if msg.to.type == "channel" then
   tdcli.changeChannelAbout(chat, matches[2], dl_cb, nil)
    elseif msg.to.type == "chat" then
    data[tostring(chat)]['about'] = matches[2]
	  save_data(_config.moderation.data, data)
     end
     if not lang then
    return "♻️*Group description* _has been set_🔅"
    else
     return "♻️پیام مبنی بر درباره گروه ثبت شد🔅"
      end
  end
  if matches[1] == "about" and msg.to.type == "chat" then
 if not data[tostring(chat)]['about'] then
     if not lang then
     about = "⚠️_No_ *description* _available_⚠️"
      elseif lang then
      about = "⚠️پیامی مبنی بر درباره گروه ثبت نشده است⚠️"
       end
        else
     about = "💠*Group Description 💠:*\n"..data[tostring(chat)]['about']
      end
    return about
  end
  if matches[1] == 'filter' and is_mod(msg) then
    return filter_word(msg, matches[2])
  end
  if matches[1] == 'unfilter' and is_mod(msg) then
    return unfilter_word(msg, matches[2])
  end
  if matches[1] == 'filterlist' and is_mod(msg) then
    return filter_list(msg)
  end
if matches[1] == "settings" then
return group_settings(msg, target)
end
if matches[1] == "mutelist" then
return mutes(msg, target)
end
if matches[1] == "managers" then
return modlist(msg)
end
if matches[1] == "ownerlist" and is_owner(msg) then
return ownerlist(msg)
end

if matches[1] == "setlang" and is_owner(msg) then
   if matches[2] == "en" then
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 redis:del(hash)
return "🌐_Group Language Set To:_ EN🌐"
  elseif matches[2] == "fa" then
redis:set(hash, true)
return "🌐*زبان گروه تنظیم شد به : فارسی*🌐"
end
end

if matches[1] == "help" and is_mod(msg) then
if not lang then
text = [[
*Help list* :
〰〰〰〰〰〰

_To Get Help sudo_
*!helpsudo*

_To Get Help mod_
*!helpmod*

_To Get Help lock_
*!helplock*

_To Get Help fun_
*!helpfun*
〰〰〰〰〰〰

]]

elseif lang then

text = [[
_لیست راهنما ها:_
〰〰〰〰〰〰

_برای دریافت راهنمای سودو_
*!sudohelp*

_برای دریافت راهنمای مدیریتی_
*!helpmod*

_برای دریافت راهنمای قفلی_
*!helplock*

_برای دریافت راهنمای  فان_
*!helpfun*
〰〰〰〰〰〰
]]
end
return text
end
if matches[1] == "helplock" and is_mod(msg) then
if not lang then
text1 = [[
*Help Lock* :
〰〰〰〰〰〰

🔒*!lock* `[link | tag | edit | arabic | webpage | bots | spam | flood | markdown | mention| pin]`
_If This Actions Lock, Bot Check Actions And Delete Them_

〰〰〰〰〰〰

🔓*!unlock*` [link | tag | edit | arabic | webpage | bots | spam | flood | markdown | mention| pin]`
_If This Actions Unlock, Bot Not Delete Them_

〰〰〰〰〰〰

🔕*!mute* `[gif | photo | document | sticker | keyboard | video | text | forward | location | audio | voice | contact | all]`
_If This Actions Lock, Bot Check Actions And Delete Them_

〰〰〰〰〰〰

🔔*!unmute* `[gif | photo | document | sticker | keyboard | video | text | forward | location | audio | voice | contact | all]`
_If This Actions Unlock, Bot Not Delete Them_

〰〰〰〰〰〰
]]

elseif lang then

text1 = [[
_راهنمای قفلی_ :
〰〰〰〰〰〰

*!lock* `[link | tag | edit | arabic | webpage | bots | spam | flood | markdown | mention| pin]`
_در صورت قفل بودن فعالیت ها, ربات آنهارا حذف خواهد کرد_

〰〰〰〰〰〰

*!unlock* `[link | tag | edit | arabic | webpage | bots | spam | flood | markdown | mention| pin]`
_در صورت قفل نبودن فعالیت ها, ربات آنهارا حذف نخواهد کرد_

〰〰〰〰〰〰

*!mute* `[gif | photo | document | sticker | keyboard | video | text | forward | location | audio | voice | contact | all]`
_در صورت بیصدا بودن فعالیت ها, ربات آنهارا حذف خواهد کرد_

〰〰〰〰〰〰

*!unmute* `[gif | photo | document | sticker | keyboard | video | text | forward | location | audio | voice | contact | all]`
_در صورت بیصدا نبودن فعالیت ها, ربات آنهارا حذف نخواهد کرد_

〰〰〰〰〰〰
]]
end
return text1
end
if matches[1] == "helpsudo" and is_sudo(msg) then
if not lang then
text2 = [[
*Help Sudo*:
〰〰〰〰〰〰

*!creategroup* `[name]`
_createing group_

*!tosuper* 
_Update to Super Group_

*!add*
_Activate the robot in the group_

*!rem*
_Disable the Robot in the Group_

*!setowner* `[username|id|reply]`
_Set Group Owner(Multi Owner)_

*!remowner* `[username|id|reply]`
_Remove User From Owner List_

*!gban* `[username|id|reply]`
_Ban User From Groups_

*!ungban* `[username|id|reply]`
_UnBan User From Groups_

*!delete* [gbans]
_Bot Clean Them_

*Cpu*
_Show server info_

*!broadcast*` [your globall massege]`
_send globally massege_

*!bc*` [group id] (your massege)`
_Send messages to group_

*!markread* `on/off`
_Read Message_

*!import* `(group link)`
_Go in with link_

*!join* `[group id]`
_Join with id_

*!chats*
_show bot groups_

*!autoleave* enable/disable
_auto left_

*!leave* 
_left in group_

*!active* `[number]`
_Set Active time_

〰〰〰〰〰〰
]]

elseif lang then

text2 = [[
_راهنمای سودو:_
〰〰〰〰〰〰

*!creategroup* `[name]`
_ساختن گروه_

*!tosuper* 
_اپدیت شدن گروه به ابر گروه_

*!add*
_فعال کردن ربات در گروه_

*!rem*
_غیر فعال کردن ربات در گروه_

*!setowner* `[username|id|reply]`
_انتخاب مالک گروه(قابل انتخاب چند مالک)_

*!remowner* `[username|id|reply]`
_ حذف کردن فرد از فهرست مالکان گروه_

*!gban* `[username|id|reply]`
_مسدود کردن کاربر از تمامی گروه ها_

*!ungban* `[username|id|reply]`
_در آوردن ار حالت مسدودیت کاربر از تمامی گروه ها_

*!delete* [gbans]
_ربات آنهارا پاک خواهد کرد_

*Cpu*
_نمایش اطلاعات سرور_

*!broadcast*` [your globall massege]`
_ارسال پیام به تمامی گروه ها_

*!bc*` [group id] (your massege)`
_ارسال پیام به یک گروه_

*!markread* `on/off`
_خوانده شدن پیام ها_

*!import* `(group link)`
_عضو شدن ربات به وسیله لینک_

*!join* `[group id]`
_پیوستن به گروه با ایدی_

*!chats*
_نمایش گروه های ربات_

*!autoleave* enable/disable
_خارج شدن اتوماتیک ربات_

*!leave* 
_خارج شدن ربات_

*!active* `[number]`
_تنظیم کردن مدت فعال بودن ربات_

〰〰〰〰〰〰
]]
end
return text2
end
if matches[1] == "helpfun" and is_mod(msg) then
if not lang then
text3 = [[
*Help Fun*:
〰〰〰〰〰〰

*!time*
_Show time_

*!ping*
_Online testing robot_

*!mypic* `[number]`
_show user photo_
				
*!rank*
_show user rank_

*New features coming soon*

〰〰〰〰〰〰
]]

elseif lang then

text3 = [[
_راهنمای فان_ :
〰〰〰〰〰〰

*!time*
_نمایش ساعت و تاریخ_

*!ping*
_تست انلاینی ربات_

*!mypic* `[number]`
_ارسال عکس پروفایل کاربر_
				
*!rank*
_نمایش مقام_

*ویژگی های جدید به زودی *

〰〰〰〰〰〰
]]
end
return text3
end
if matches[1] == "helpmod" and is_mod(msg) then
if not lang then
text4 = [[
*Help Mod*:
〰〰〰〰〰〰

*!modset* `[username|id|reply]`
_Promote User To Group Admin_

*!moddem* `[username|id|reply]`
_Demote User From Group Admins List_

*!silentuser* `[username|id|reply]` 
_Silent User From Group_

*!unsilentuser* `[username|id|reply]` 
_Unsilent User From Group_

*!kick* `[username|id|reply]`
_Kick User From Group_

*!ban* `[username|id|reply]` 
_Ban User From Group_

*!unban* `[username|id|reply]` 
_UnBan User From Group_

*!floodmax* `[1-200]`
_Set Flooding Number_

*!res* `[username]`
_Show User ID_

*!userid* `[reply]`
_Show User ID_

*!whois* `[id]`
_Show User's Username And Name_

*!set* `[rules | name | photo | link | about | welcome]`
_Bot Set Them_
    
*!delete* `[bans | mods | bots | rules | about | silentlist | filtelist | welcome]`   
_Bot Clean Them_

*!welcome* `enable/disable`
_Enable Or Disable Group Welcome_

*!setwelcome* `[text]`
_set Welcome Message_

*!del* `[number]`
_delete group massege_

*!delall* `[username|id|reply]` 
_delete all user massege_

*!id*
_Show Your And Chat ID_

*!gpinfo*
_Show Group Information_

*!newlink*
_Create A New Link_
    
*!link*
_Show Group Link_

*!filter* `[word]`
_Word filter_
    
*!unfilter* `[word]`
_Word unfilter_
    
*!pin* `[reply]`
_Pin Your Message_
    
*!unpin*
_Unpin Pinned Message_

*!settings*
_Show Group Settings_
    
*!mutelist*
_Show Mutes List_
    
*!silentlist*
_Show Silented Users List_
    
*!filterlist*
_Show Filtered Words List_
    
*!banlist*
_Show Banned Users List_
    
*!ownerlist*
_Show Group Owners List_
   
*!managers*
_Show Group Moderators List_
    
*!rules*
_Show Group Rules_
    
*!about*
_Show Group Description_

*!active time*
_show expire time_

_You Can Use [!/#] To Run The Commands_

〰〰〰〰〰〰
 ]]

elseif lang then

text4 = [[
_راهنمای مدیریتی_ :
〰〰〰〰〰〰

*!modset* `[username|id|reply]`
_ارتقا مقام کاربر به مدیر گروه_

*!moddem* `[username|id|reply]`
_تنزیل مقام مدیر به کاربر_

*!silentuser* `[username|id|reply]` 
_بیصدا کردن کاربر در گروه_

*!unsilentuser* `[username|id|reply]` 
_در آوردن کاربر از حالت بیصدا در گروه_

*!kick* `[username|id|reply]`
_حذف کاربر از گروه_

*!ban* `[username|id|reply]` 
_مسدود کردن کاربر از گروه_

*!unban* `[username|id|reply]` 
_در آوردن از حالت مسدودیت کاربر از گروه_

*!floodmax* `[1-200]`
_تنظیم حداکثر تعداد پیام مکرر_

*!res* `[username]`
_نمایش شناسه کاربر_

*!userid* `[reply]`
_نمایش شناسه کاربر_

*!whois* `[id]`
_نمایش نام کاربر, نام کاربری و اطلاعات حساب_

*!set* `[rules | name | photo | link | about | welcome]`
_ربات آنهارا ثبت خواهد کرد_
    
*!delete* `[bans | mods | bots | rules | about | silentlist | filtelist | welcome]`   
_ربات آنهارا پاک خواهد کرد_

*!welcome* `enable/disable`
_فعال یا غیرفعال کردن خوشآمد گویی_

*!setwelcome* `[text]`
_ثبت پیام خوش آمد گویی_

*!del* `[number]`
_پاک کردن پیام های گروه_

*!delall* `[username|id|reply]` 
_پاک کردن پیام های یک فرد_

*!id*
_نمایش شناسه شما و گروه_

*!gpinfo*
_نمایش اطلاعات گروه_

*!newlink*
_ساخت لینک جدید_
    
*!link*
_نمایش لینک گروه_

*!filter* `[word]`
_فیلتر‌کلمه مورد نظر_
    
*!unfilter* `[word]`
_ازاد کردن کلمه مورد نظر_
    
*!pin* `[reply]`
_ربات پیام شمارا در گروه سنجاق خواهد کرد_
    
*!unpin*
_ربات پیام سنجاق شده در گروه را حذف خواهد کرد_

*!settings*
_نمایش تنظیمات گروه_
    
*!mutelist*
_نمایش فهرست بیصدا های گروه_
    
*!silentlist*
_نمایش فهرست افراد بیصدا_
    
*!filterlist*
_نمایش لیست کلمات فیلتر شده_
    
*!banlist*
_نمایش افراد مسدود شده از گروه_
    
*!ownerlist*
_نمایش فهرست مالکان گروه _
   
*!managers*
_نمایش فهرست مدیران گروه_
    
*!rules*
_نمایش قوانین گروه_
    
*!about*
_نمایش درباره گروه_

*!active time*
_نمایش تاریخ انقضا_

_شما میتوانید از [!/#] در اول دستورات برای اجرای آنها بهره بگیرید_
〰〰〰〰〰〰
]]
end
return text4
end
if matches[1] == "help" and not is_mod(msg) then
if not lang then
text5 = [[
*Error*
_You're not a robot Manager_
]]

elseif lang then

text5 = [[
`اخطار❢`
_شما مدیر ربات نیستید_
]]
end
return text5
end
end



local function pre_process(msg)
 local chat = msg.to.id
   local user = msg.from.id
 local data = load_data(_config.moderation.data)
	local function welcome_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
		administration = load_data(_config.moderation.data)
    if administration[arg.chat_id]['setwelcome'] then
     welcome = administration[arg.chat_id]['setwelcome']
      else
     if not lang then
     welcome = "🎋*Welcome*🌹"
    elseif lang then
     welcome = "🎋_خوش آمدید_🌹"
        end
     end
 if administration[tostring(arg.chat_id)]['rules'] then
rules = administration[arg.chat_id]['rules']
else
   if not lang then
     rules = "ℹ️ The Default Rules :\n1⃣ No Flood.\n2⃣ No Spam.\n3⃣ No Advertising.\n4⃣ Try to stay on topic.\n5⃣ Forbidden any racist, sexual, homophobic or gore content.\n➡️ Repeated failure to comply with these rules will cause ban.\n:D"
    elseif lang then
       rules = "ℹ️ قوانین پپیشفرض:\n1⃣ ارسال پیام مکرر ممنوع.\n2⃣ اسپم ممنوع.\n3⃣ تبلیغ ممنوع.\n4⃣ سعی کنید از موضوع خارج نشید.\n5⃣ هرنوع نژاد پرستی, شاخ بازی و پورنوگرافی ممنوع .\n➡️ از قوانین پیروی کنید, در صورت عدم رعایت قوانین اول اخطار و در صورت تکرار مسدود.\n:D"
 end
end
if data.username_ then
user_name = "@"..check_markdown(data.username_)
else
user_name = ""
end
		local welcome = welcome:gsub("{rules}", rules)
		local welcome = welcome:gsub("{name}", check_markdown(data.first_name_))
		local welcome = welcome:gsub("{username}", user_name)
		local welcome = welcome:gsub("{gpname}", arg.gp_name)
		tdcli.sendMessage(arg.chat_id, arg.msg_id, 0, welcome, 0, "md")
	end
	if data[tostring(chat)] and data[tostring(chat)]['settings'] then
	if msg.adduser then
		welcome = data[tostring(msg.to.id)]['settings']['welcome']
		if welcome == "yes" then
			tdcli_function ({
	      ID = "GetUser",
      	user_id_ = msg.adduser
    	}, welcome_cb, {chat_id=chat,msg_id=msg.id,gp_name=msg.to.title})
		else
			return false
		end
	end
	if msg.joinuser then
		welcome = data[tostring(msg.to.id)]['settings']['welcome']
		if welcome == "yes" then
			tdcli_function ({
	      ID = "GetUser",
      	user_id_ = msg.joinuser
    	}, welcome_cb, {chat_id=chat,msg_id=msg.id,gp_name=msg.to.title})
		else
			return false
        end
		end
	end
 if msg.to.type ~= 'pv' then
chat = msg.to.id
user = msg.from.id
	local function check_newmember(arg, data)
		test = load_data(_config.moderation.data)
		lock_bots = test[arg.chat_id]['settings']['lock_bots']
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    if data.type_.ID == "UserTypeBot" then
      if not is_owner(arg.msg) and lock_bots == 'yes' then
kick_user(data.id_, arg.chat_id)
end
end
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if is_banned(data.id_, arg.chat_id) then
   if not lang then
		tdcli.sendMessage(arg.chat_id, arg.msg_id, 0, "*Done!*\n`User Has been Banned`\n*User info:*\n_Username:_ "..user_name.."\n_User id :_*[ "..data.id_.." ]*", 0, "md")
   else
		tdcli.sendMessage(arg.chat_id, arg.msg_id, 0, "_انجام شد!_\n `کاربر از گروه محروم شد`\n ` اطلاعات کاربر:`\n_یوزرنیم:_ "..user_name.."\n_ایدی:_ *"..data.id_.."*", 0, "md")
end
kick_user(data.id_, arg.chat_id)
end
if is_gbanned(data.id_) then
     if not lang then
		tdcli.sendMessage(arg.chat_id, arg.msg_id, 0, "*Done!*\n`User has been Globally Banned`\n*User Info:*\n_User name:_ "..user_name.."\n_User Id:_ *"..data.id_.."*", 0, "md")
    else
		tdcli.sendMessage(arg.chat_id, arg.msg_id, 0, "_انجام شد!_\n`کاربرازتمام گروه های بات محروم شد`\n`اطلاعات کاربر:`\n _یوزرنیم:_ "..user_name.."\n_آیدی:_ *"..data.id_.."*", 0, "md")
   end
kick_user(data.id_, arg.chat_id)
     end
	end
	if msg.adduser then
			tdcli_function ({
	      ID = "GetUser",
      	user_id_ = msg.adduser
    	}, check_newmember, {chat_id=chat,msg_id=msg.id,user_id=user,msg=msg})
	end
	if msg.joinuser then
			tdcli_function ({
	      ID = "GetUser",
      	user_id_ = msg.joinuser
    	}, check_newmember, {chat_id=chat,msg_id=msg.id,user_id=user,msg=msg})
	end
if is_silent_user(user, chat) then
del_msg(msg.to.id, msg.id)
end
if is_banned(user, chat) then
del_msg(msg.to.id, tonumber(msg.id))
    kick_user(user, chat)
   end
if is_gbanned(user) then
del_msg(msg.to.id, tonumber(msg.id))
    kick_user(user, chat)
      end
   end
    if data[tostring(chat)] and data[tostring(chat)]['mutes'] then
		mutes = data[tostring(chat)]['mutes']
	else
		return
	end
	if mutes.mute_all then
		mute_all = mutes.mute_all
	else
		mute_all = 'no'
	end
	if mutes.mute_gif then
		mute_gif = mutes.mute_gif
	else
		mute_gif = 'no'
	end
   if mutes.mute_photo then
		mute_photo = mutes.mute_photo
	else
		mute_photo = 'no'
	end
	if mutes.mute_sticker then
		mute_sticker = mutes.mute_sticker
	else
		mute_sticker = 'no'
	end
	if mutes.mute_contact then
		mute_contact = mutes.mute_contact
	else
		mute_contact = 'no'
	end
	if mutes.mute_inline then
		mute_inline = mutes.mute_inline
	else
		mute_inline = 'no'
	end
	if mutes.mute_game then
		mute_game = mutes.mute_game
	else
		mute_game = 'no'
	end
	if mutes.mute_text then
		mute_text = mutes.mute_text
	else
		mute_text = 'no'
	end
	if mutes.mute_keyboard then
		mute_keyboard = mutes.mute_keyboard
	else
		mute_keyboard = 'no'
	end
	if mutes.mute_forward then
		mute_forward = mutes.mute_forward
	else
		mute_forward = 'no'
	end
	if mutes.mute_location then
		mute_location = mutes.mute_location
	else
		mute_location = 'no'
	end
   if mutes.mute_document then
		mute_document = mutes.mute_document
	else
		mute_document = 'no'
	end
	if mutes.mute_voice then
		mute_voice = mutes.mute_voice
	else
		mute_voice = 'no'
	end
	if mutes.mute_audio then
		mute_audio = mutes.mute_audio
	else
		mute_audio = 'no'
	end
	if mutes.mute_video then
		mute_video = mutes.mute_video
	else
		mute_video = 'no'
	end
	if mutes.mute_tgservice then
		mute_tgservice = mutes.mute_tgservice
	else
		mute_tgservice = 'no'
	end
	if data[tostring(chat)] and data[tostring(chat)]['settings'] then
		settings = data[tostring(chat)]['settings']
	else
		return
	end
	if settings.lock_link then
		lock_link = settings.lock_link
	else
		lock_link = 'no'
	end
	if settings.lock_tag then
		lock_tag = settings.lock_tag
	else
		lock_tag = 'no'
	end
	if settings.lock_pin then
		lock_pin = settings.lock_pin
	else
		lock_pin = 'no'
	end
	if settings.lock_arabic then
		lock_arabic = settings.lock_arabic
	else
		lock_arabic = 'no'
	end
	if settings.lock_mention then
		lock_mention = settings.lock_mention
	else
		lock_mention = 'no'
	end
		if settings.lock_edit then
		lock_edit = settings.lock_edit
	else
		lock_edit = 'no'
	end
		if settings.lock_spam then
		lock_spam = settings.lock_spam
	else
		lock_spam = 'no'
	end
	if settings.flood then
		lock_flood = settings.flood
	else
		lock_flood = 'no'
	end
	if settings.lock_markdown then
		lock_markdown = settings.lock_markdown
	else
		lock_markdown = 'no'
	end
	if settings.lock_webpage then
		lock_webpage = settings.lock_webpage
	else
		lock_webpage = 'no'
	end
  if msg.adduser or msg.joinuser or msg.deluser then
  if mute_tgservice == "yes" then
del_msg(chat, tonumber(msg.id))
  end
end
   if msg.pinned and is_channel then
  if lock_pin == "yes" then
     if is_owner(msg) then
      return
     end
     if tonumber(msg.from.id) == our_id then
      return
     end
    local pin_msg = data[tostring(chat)]['pin']
      if pin_msg then
  tdcli.pinChannelMessage(msg.to.id, pin_msg, 1)
       elseif not pin_msg then
   tdcli.unpinChannelMessage(msg.to.id)
          end
    if lang then
     tdcli.sendMessage(msg.to.id, msg.id, 0, '<b>User ID :</b> <code>'..msg.from.id..'</code>\n<b>Username :</b> '..('@'..msg.from.username or '<i>No Username</i>')..'\n<i>شما اجازه دسترسی به سنجاق پیام را ندارید، به همین دلیل پیام قبلی مجدد سنجاق میگردد</i>', 0, "html")
     elseif not lang then
    tdcli.sendMessage(msg.to.id, msg.id, 0, '<b>User ID :</b> <code>'..msg.from.id..'</code>\n<b>Username :</b> '..('@'..msg.from.username or '<i>No Username</i>')..'\n<i>You Have Not Permission To Pin Message, Last Message Has Been Pinned Again</i>', 0, "html")
          end
      end
  end
      if not is_mod(msg) then
if msg.edited and lock_edit == "yes" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
    end
  end
if msg.forward_info_ and mute_forward == "yes" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
    end
  end
if msg.photo_ and mute_photo == "yes" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.video_ and mute_video == "yes" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.document_ and mute_document == "yes" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.sticker_ and mute_sticker == "yes" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.animation_ and mute_gif == "yes" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.contact_ and mute_contact == "yes" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.location_ and mute_location == "yes" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.voice_ and mute_voice == "yes" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
   if msg.content_ and mute_keyboard == "yes" then
  if msg.reply_markup_ and  msg.reply_markup_.ID == "ReplyMarkupInlineKeyboard" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
      end
   end
end
    if tonumber(msg.via_bot_user_id_) ~= 0 and mute_inline == "yes" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.game_ and mute_game == "yes" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
    if msg.audio_ and mute_audio == "yes" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
if msg.media.caption then
local link_caption = msg.media.caption:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.media.caption:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or msg.media.caption:match("[Tt].[Mm][Ee]/") or msg.media.caption:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
if link_caption
and lock_link == "yes" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
local tag_caption = msg.media.caption:match("@") or msg.media.caption:match("#")
if tag_caption and lock_tag == "yes" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
if is_filter(msg, msg.media.caption) then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
      end
    end
local arabic_caption = msg.media.caption:match("[\216-\219][\128-\191]")
if arabic_caption and lock_arabic == "yes" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
      end
   end
end
if msg.text then
			local _nl, ctrl_chars = string.gsub(msg.text, '%c', '')
			 local _nl, real_digits = string.gsub(msg.text, '%d', '')
			if lock_spam == "yes" then
   if string.len(msg.text) > 2049 or ctrl_chars > 40 or real_digits > 2000 then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
      end
   end
end
local link_msg = msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or msg.text:match("[Tt].[Mm][Ee]/") or msg.text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
if link_msg
and lock_link == "yes" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
local tag_msg = msg.text:match("@") or msg.text:match("#")
if tag_msg and lock_tag == "yes" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
if is_filter(msg, msg.text) then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
      end
    end
local arabic_msg = msg.text:match("[\216-\219][\128-\191]")
if arabic_msg and lock_arabic == "yes" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
if msg.text:match("(.*)")
and mute_text == "yes" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
     end
   end
end
if mute_all == "yes" then 
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
   end
end
if msg.content_.entities_ and msg.content_.entities_[0] then
    if msg.content_.entities_[0].ID == "MessageEntityMentionName" then
      if lock_mention == "yes" then
 if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
             end
          end
      end
  if msg.content_.entities_[0].ID == "MessageEntityUrl" or msg.content_.entities_[0].ID == "MessageEntityTextUrl" then
      if lock_webpage == "yes" then
if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
             end
          end
      end
  if msg.content_.entities_[0].ID == "MessageEntityBold" or msg.content_.entities_[0].ID == "MessageEntityCode" or msg.content_.entities_[0].ID == "MessageEntityPre" or msg.content_.entities_[0].ID == "MessageEntityItalic" then
      if lock_markdown == "yes" then
if is_channel then
 del_msg(chat, tonumber(msg.id))
  elseif is_chat then
kick_user(user, chat)
             end
          end
      end
 end
if msg.to.type ~= 'pv' then
  if lock_flood == "yes" then
    local hash = 'user:'..user..':msgs'
    local msgs = tonumber(redis:get(hash) or 0)
        local NUM_MSG_MAX = 5
        if data[tostring(chat)] then
          if data[tostring(chat)]['settings']['num_msg_max'] then
            NUM_MSG_MAX = tonumber(data[tostring(chat)]['settings']['num_msg_max'])
          end
        end
    if msgs > NUM_MSG_MAX then
  if is_mod(msg) then
    return
  end
  if msg.adduser and msg.from.id then
    return
  end
   if msg.from.username then
      user_name = "@"..msg.from.username
         else
      user_name = msg.from.first_name
     end
if redis:get('sender:'..user..':flood') then
return
else
   del_msg(chat, msg.id)
    kick_user(user, chat)
   if not lang then
  tdcli.sendMessage(chat, msg.id, 0, "*done!*\n `user has been kicked` \nReason : flooding\n *user info* :\nuserid : [ "..user.." ]", 0, "md")
   elseif lang then
  tdcli.sendMessage(chat, msg.id, 0, "`انجام شد!`\n `کاربر اخراج شد `\n علت : پیام های مکرر\n اطلاعات کاربر:\n ایدی کاربر :  [ "..user.." ]", 0, "md")
    end
redis:setex('sender:'..user..':flood', 30, true)
      end
    end
    redis:setex(hash, TIME_CHECK, msgs+1)
               end
           end
      end
   end
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
local data = load_data(_config.moderation.data)
chat = msg.to.id
user = msg.from.id
   if msg.to.type ~= 'pv' then
 

if matches[1] == "lock" and is_mod(msg) then
local target = msg.to.id
if matches[2] == "link" then
return lock_link(msg, data, target)
end
if matches[2] == "tag" then
return lock_tag(msg, data, target)
end
if matches[2] == "mention" then
return lock_mention(msg, data, target)
end
if matches[2] == "arabic" then
return lock_arabic(msg, data, target)
end
if matches[2] == "edit" then
return lock_edit(msg, data, target)
end
if matches[2] == "spam" then
return lock_spam(msg, data, target)
end
if matches[2] == "flood" then
return lock_flood(msg, data, target)
end
if matches[2] == "bots" then
return lock_bots(msg, data, target)
end
if matches[2] == "markdown" then
return lock_markdown(msg, data, target)
end
if matches[2] == "webpage" then
return lock_webpage(msg, data, target)
end
if matches[2] == "pin" and is_owner(msg) then
return lock_pin(msg, data, target)
end
end

if matches[1] == "unlock" and is_mod(msg) then
local target = msg.to.id
if matches[2] == "link" then
return unlock_link(msg, data, target)
end
if matches[2] == "tag" then
return unlock_tag(msg, data, target)
end
if matches[2] == "mention" then
return unlock_mention(msg, data, target)
end
if matches[2] == "arabic" then
return unlock_arabic(msg, data, target)
end
if matches[2] == "edit" then
return unlock_edit(msg, data, target)
end
if matches[2] == "spam" then
return unlock_spam(msg, data, target)
end
if matches[2] == "flood" then
return unlock_flood(msg, data, target)
end
if matches[2] == "bots" then
return unlock_bots(msg, data, target)
end
if matches[2] == "markdown" then
return unlock_markdown(msg, data, target)
end
if matches[2] == "webpage" then
return unlock_webpage(msg, data, target)
end
if matches[2] == "pin" and is_owner(msg) then
return unlock_pin(msg, data, target)
end
end
if matches[1] == "mute" and is_mod(msg) then
local target = msg.to.id
if matches[2] == "all" then
return mute_all(msg, data, target)
end
if matches[2] == "gif" then
return mute_gif(msg, data, target)
end
if matches[2] == "text" then
return mute_text(msg ,data, target)
end
if matches[2] == "photo" then
return mute_photo(msg ,data, target)
end
if matches[2] == "video" then
return mute_video(msg ,data, target)
end
if matches[2] == "audio" then
return mute_audio(msg ,data, target)
end
if matches[2] == "voice" then
return mute_voice(msg ,data, target)
end
if matches[2] == "sticker" then
return mute_sticker(msg ,data, target)
end
if matches[2] == "contact" then
return mute_contact(msg ,data, target)
end
if matches[2] == "forward" then
return mute_forward(msg ,data, target)
end
if matches[2] == "location" then
return mute_location(msg ,data, target)
end
if matches[2] == "document" then
return mute_document(msg ,data, target)
end
if matches[2] == "tgservice" then
return mute_tgservice(msg ,data, target)
end
if matches[2] == "inline" then
return mute_inline(msg ,data, target)
end
if matches[2] == "game" then
return mute_game(msg ,data, target)
end
if matches[2] == "keyboard" then
return mute_keyboard(msg ,data, target)
end
end

if matches[1] == "unmute" and is_mod(msg) then
local target = msg.to.id
if matches[2] == "all" then
return unmute_all(msg, data, target)
end
if matches[2] == "gif" then
return unmute_gif(msg, data, target)
end
if matches[2] == "text" then
return unmute_text(msg, data, target)
end
if matches[2] == "photo" then
return unmute_photo(msg ,data, target)
end
if matches[2] == "video" then
return unmute_video(msg ,data, target)
end
if matches[2] == "audio" then
return unmute_audio(msg ,data, target)
end
if matches[2] == "voice" then
return unmute_voice(msg ,data, target)
end
if matches[2] == "sticker" then
return unmute_sticker(msg ,data, target)
end
if matches[2] == "contact" then
return unmute_contact(msg ,data, target)
end
if matches[2] == "forward" then
return unmute_forward(msg ,data, target)
end
if matches[2] == "location" then
return unmute_location(msg ,data, target)
end
if matches[2] == "document" then
return unmute_document(msg ,data, target)
end
if matches[2] == "tgservice" then
return unmute_tgservice(msg ,data, target)
end
if matches[2] == "inline" then
return unmute_inline(msg ,data, target)
end
if matches[2] == "game" then
return unmute_game(msg ,data, target)
end
if matches[2] == "keyboard" then
return unmute_keyboard(msg ,data, target)
end
end

end
 end

	



return {
description = "Plugin to manage other plugins. Enable, disable or reload.", 
  usage = {
      moderator = {
          "!plug disable [plugin] chat : disable plugin only this chat.",
          "!plug enable [plugin] chat : enable plugin only this chat.",
          },
      sudo = {
          "!plist : list all plugins.",
          "!pl + [plugin] : enable plugin.",
          "!pl - [plugin] : disable plugin.",
          "!pl * : reloads all plugins." },
          },
patterns ={
"^[!/#](visudo)$", 
"^[!/#](desudo)$",
"^[!/#](sudolist)$",
"^[!/#](visudo) (.*)$", 
"^[!/#](desudo) (.*)$",
"^[!/#](adminprom)$", 
"^[!/#](admindem)$",
"^[!/#](adminlist)$",
"^[!/#](adminprom) (.*)$", 
"^[!/#](admindem) (.*)$",
"^[!/#](leave)$",
"^[!/#](autoleave) (.*)$", 
"^[!/#](secure)$",
"^[!/#](creategroup) (.*)$",
"^[!/#](createsuper) (.*)$",
"^[!/#](tosuper)$",
"^[!/#](chats)$",
"^[!/#](join) (.*)$",
"^[!/#](rem) (.*)$",
"^[!/#](import) (.*)$",
"^[!/#](setbotname) (.*)$",
"^[!/#](setbotusername) (.*)$",
"^[!/#](delbotusername) (.*)$",
"^[!/#](markread) (.*)$",
"^[!/#](bc) (%d+) (.*)$",
"^[!/#](broadcast) (.*)$",
"^[!/#]plist$",
    "^[!/#](pl) (+) ([%w_%.%-]+)$",
    "^[!/#](pl) (-) ([%w_%.%-]+)$",
    "^[!/#](pl) (+) ([%w_%.%-]+) (chat)",
    "^[!/#](pl) (-) ([%w_%.%-]+) (chat)",
    "^!pl? (*)$",
    "^[!/](reload)$",
"^[!/#](userid)$",
"^[!/#](userid) (.*)$",
"^[!/#](pin)$",
"^[!/#](unpin)$",
"^[!/#](gpinfo)$",
"^[!/#](test)$",
"^[!/#](add)$",
"^[!/#](rem)$",
"^[!/#](setowner)$",
"^[!/#](setowner) (.*)$",
"^[!/#](remowner)$",
"^[!/#](remowner) (.*)$",
"^[!/#](modset)$",
"^[!/#](modset) (.*)$",
"^[!/#](moddem)$",
"^[!/#](moddem) (.*)$",
"^[!/#](managers)$",
"^[!/#](ownerlist)$",
"^[!/#](lock) (.*)$",
"^[!/#](unlock) (.*)$",
"^[!/#](settings)$",
"^[!/#](mutelist)$",
"^[!/#](mute) (.*)$",
"^[!/#](unmute) (.*)$",
"^[!/#](link)$",
"^[!/#](setlink)$",
"^[!/#](newlink)$",
"^[!/#](rules)$",
"^[!/#](setrules) (.*)$",
"^[!/#](about)$",
"^[!/#](setabout) (.*)$",
"^[!/#](setname) (.*)$",
"^[!/#](delete) (.*)$",
"^[!/#](floodmax) (%d+)$",
"^[!/#](res) (.*)$",
"^[!/#](whois) (%d+)$",
"^[!/#](help)$",
"^[!/#](helplock)$",
"^[!/#](helpsudo)$",
"^[!/#](helpfun)$",
"^[!/#](helpmod)$",
"^[!/#](setlang) (.*)$",
"^[#!/](filter) (.*)$",
"^[#!/](unfilter) (.*)$",
"^[#!/](filterlist)$",
"^([https?://w]*.?t.me/joinchat/%S+)$",
"^([https?://w]*.?telegram.me/joinchat/%S+)$",
"^[!/#](setwelcome) (.*)",
"^[!/#](welcome) (.*)$",
"^[!/#](gban)$",
		"^[!/#](gban) (.*)$",
		"^[!/#](ungban)$",
		"^[!/#](ungban) (.*)$",
		"^[!/#](gbanlist)$",
		"^[!/#](ban)$",
		"^[!/#](ban) (.*)$",
		"^[!/#](unban)$",
		"^[!/#](unban) (.*)$",
		"^[!/#](banlist)$",
		"^[!/#](silentuser)$",
		"^[!/#](silentuser) (.*)$",
		"^[!/#](unsilentuser)$",
		"^[!/#](unsilentuser) (.*)$",
		"^[!/#](silentlist)$",
		"^[!/#](kick)$",
		"^[!/#](kick) (.*)$",
		"^[!/#](delall)$",
		"^[!/#](delall) (.*)$",
		"^[!/#](delete) (.*)$",
		"^[!/#]([Ii][Dd])$","^[/!#]([Ii][Nn][Ff][Oo])$","^[!/#](mypic) (%d+)$","^[/!]([Tt][iI][Mm][Ee])$",'^[!#/]([Dd][Ee][Ll]) (%d*)$',"^[/#+×!$]([Oo][Nn][Ll][Ii][Nn][Ee])","^[/#+×!$]([Pp][Ii][Nn][Gg])","^[!#/](setnerkh) (.*)$", "^[!#/](nerkh)$","^نرخ$", "^[!#/](delnerkh)$",'^[Cc][Pp][Uu]$',"^[!#/]([Rr][Aa][Nn][Kk])$","^[Rr][Aa][Nn][Kk]$"
},
run=run,
pre_process = pre_process
}
--end groupmanager.lua #secure-team
