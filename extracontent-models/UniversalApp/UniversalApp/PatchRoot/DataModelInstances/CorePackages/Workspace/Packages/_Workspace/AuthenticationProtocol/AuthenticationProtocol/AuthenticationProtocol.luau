local ParentParent = script.Parent.Parent
local Promise = require(ParentParent.Promise)
local MessageBus = require(ParentParent.MessageBus).MessageBus
local t = require(ParentParent.t)

require(script.Parent.AuthenticationProtocolTypes)

local t1 = {
	MSDK = "MSDK"
}
local t2 = {
	PC = "Win32",
	Mac = "MacOS",
	Android = "Android",
	IOS = "iOS"
}
local t3 = {
	WECHAT = "WeChat",
	QQ = "QQ",
	NONE = "None"
}
local _ = {
	eFlag_Succ = 0,
	eFlag_QQ_UserCancel = 1001,
	eFlag_QQ_LoginFail = 1002,
	eFlag_QQ_NetworkErr = 1003,
	eFlag_QQ_NotInstall = 1004,
	eFlag_QQ_NotSupportApi = 1005,
	eFlag_WX_NotInstall = 2000,
	eFlag_WX_NotSupportApi = 2001,
	eFlag_WX_UserCancel = 2002,
	eFlag_WX_LoginFail = 2004,
	eFlag_Need_Realname_Auth = 3005,
	eFlag_Need_MSDK_Realname_Auth = 3006,
	eFlag_Local_Invalid = -2
}
local t4 = {
	[0] = "",
	[2000] = "Authentication.Login.WeChat.NotInstalled",
	[2001] = "Authentication.Login.Label.WeChatVersionNotSupported",
	[2002] = "Authentication.Login.Label.WeChatUserCancel",
	[2004] = "Authentication.Login.Response.TencentLoginFailurePleaseTryAgain",
	[1001] = "Authentication.Login.Label.QQUserCancel",
	[1002] = "Authentication.Login.Response.TencentLoginFailurePleaseTryAgain"
}
local t5 = {
	[t1.MSDK] = t4
}
local t6 = {
	[t1.MSDK] = "Authentication.Login.Response.TencentLoginFailurePleaseTryAgain"
}
local v12 = t.valueOf(t1)
local v13 = t.valueOf(t2)
local v14 = t.valueOf(t3)
local t7 = {
	AuthProviders = t1,
	AuthMethods = t3,
	AUTH_REQUEST_DESCRIPTOR = {
		mid = MessageBus.getMessageId("Authentication", "authRequest"),
		validateParams = t.strictInterface({
			authProvider = v12,
			authMethod = v14
		})
	},
	AUTH_RESPONSE_DESCRIPTORS = {
		[t1.MSDK] = {
			mid = MessageBus.getMessageId("Authentication", "MSDKAuthResponse"),
			validateParams = t.strictInterface({
				platform = v13,
				status = t.number,
				tokenAuthBody = t.optional(t.strictInterface({
					openId = t.string,
					accessToken = t.string,
					refreshToken = t.string,
					accessTokenExpiry = t.number,
					refreshTokenExpiry = t.number,
					channelId = t.number
				}))
			})
		}
	}
}

t7.__index = t7

function t7.new() -- line: 130
	-- upvalues: MessageBus (copy), t7 (copy)
	return (setmetatable({
		subscriber = MessageBus.Subscriber.new()
	}, t7))
end
function t7.requestAuth(t8: {[any]: any}, s1: string, s2: string) -- line: 144
	-- upvalues: Promise (copy), t5 (copy), t6 (copy), MessageBus (copy)
	local v19 = Promise.new(function(resolve, _) -- line: 145
		-- upvalues: t8 (copy), s1 (copy), t5 (copy), t6 (copy)
		local v24 = t8.AUTH_RESPONSE_DESCRIPTORS[s1]

		t8.subscriber:subscribe(v24, function(p2) -- line: 148
			-- upvalues: t8 (copy), v24 (copy), s1 (copy), t5 (copy), t6 (copy), resolve (copy)
			t8.subscriber:unsubscribe(v24)

			local t9 = nil

			if s1 == t8.AuthProviders.MSDK then
				t9 = {
					statusCode = p2.status,
					tokenAuthBody = p2.tokenAuthBody,
					errMessageKey = t5[s1][p2.status] or t6[s1]
				}
			end

			resolve(t9)
		end)
	end)

	MessageBus.publish(t8.AUTH_REQUEST_DESCRIPTOR, {
		authProvider = s1,
		authMethod = s2
	})

	return v19
end
function t7.listenWebAuthResponset(t10: {[any]: any}, s3: string) -- line: 177
	-- upvalues: Promise (copy), t5 (copy), t6 (copy)
	return (Promise.new(function(resolve, _) -- line: 178
		-- upvalues: t10 (copy), s3 (copy), t5 (copy), t6 (copy)
		local v27 = t10.AUTH_RESPONSE_DESCRIPTORS[s3]

		t10.subscriber:subscribe(v27, function(p4) -- line: 181
			-- upvalues: t10 (copy), v27 (copy), s3 (copy), t5 (copy), t6 (copy), resolve (copy)
			t10.subscriber:unsubscribe(v27)

			local t11 = nil

			if s3 == t10.AuthProviders.MSDK then
				t11 = {
					statusCode = p4.status,
					tokenAuthBody = p4.tokenAuthBody,
					errMessageKey = t5[s3][p4.status] or t6[s3]
				}
			end

			resolve(t11)
		end)
	end))
end

t7.default = t7.new()

return t7
