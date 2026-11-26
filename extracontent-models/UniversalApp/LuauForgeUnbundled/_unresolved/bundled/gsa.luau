local module = require("@luauforge/bundled/gsb")
local messageBus = require("@luauforge/bundled/gsc").MessageBus

local module2 = require("@luauforge/bundled/gsd")

require("@luauforge/bundled/gse")

local v5 = { MSDK = "MSDK" }

local v6 = { WECHAT = "WeChat", QQ = "QQ", NONE = "None" }

local v7 = {
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

local v8 = {
	[v5.MSDK] = {
		[0] = "",
		[2000] = "Authentication.Login.WeChat.NotInstalled",
		[2001] = "Authentication.Login.Label.WeChatVersionNotSupported",
		[2002] = "Authentication.Login.Label.WeChatUserCancel",
		[2004] = "Authentication.Login.Response.TencentLoginFailurePleaseTryAgain",
		[1001] = "Authentication.Login.Label.QQUserCancel",
		[1002] = "Authentication.Login.Response.TencentLoginFailurePleaseTryAgain"
	}
}

local v9 = {
	[v5.MSDK] = "Authentication.Login.Response.TencentLoginFailurePleaseTryAgain"
}

local value = module2.valueOf(v5)
local value2 = module2.valueOf({
	PC = "Win32",
	Mac = "MacOS",
	Android = "Android",
	IOS = "iOS"
})
local value3 = module2.valueOf(v6)

local v10 = {
	AuthProviders = v5,
	AuthMethods = v6,
	AUTH_REQUEST_DESCRIPTOR = {
		mid = messageBus.getMessageId("Authentication", "authRequest"),
		validateParams = module2.strictInterface({
			authProvider = value,
			authMethod = value3
		})
	},
	AUTH_RESPONSE_DESCRIPTORS = {
		[v5.MSDK] = {
			mid = messageBus.getMessageId("Authentication", "MSDKAuthResponse"),
			validateParams = module2.strictInterface({
				platform = value2,
				status = module2.number,
				tokenAuthBody = module2.optional(module2.strictInterface({
					openId = module2.string,
					accessToken = module2.string,
					refreshToken = module2.string,
					accessTokenExpiry = module2.number,
					refreshTokenExpiry = module2.number,
					channelId = module2.number
				}))
			})
		}
	}
}

v10.__index = v10

function v10.new()
	return (setmetatable({ subscriber = messageBus.Subscriber.new() }, v10))
end

function v10:requestAuth(p2, p3)
	local auth = module.new(function(callback, p4)
		local v12 = self.AUTH_RESPONSE_DESCRIPTORS[p2]

		self.subscriber:subscribe(v12, function(p5)
			self.subscriber:unsubscribe(v12)

			callback(p2 == self.AuthProviders.MSDK and {
				statusCode = p5.status,
				tokenAuthBody = p5.tokenAuthBody,
				errMessageKey = v8[p2][p5.status] or v9[p2]
			} or nil)
		end)
	end)

	messageBus.publish(self.AUTH_REQUEST_DESCRIPTOR, {
		authProvider = p2,
		authMethod = p3
	})

	return auth
end

function v10:listenWebAuthResponset(p2)
	return (module.new(function(callback, p3)
		local v12 = self.AUTH_RESPONSE_DESCRIPTORS[p2]

		self.subscriber:subscribe(v12, function(p4)
			self.subscriber:unsubscribe(v12)

			callback(p2 == self.AuthProviders.MSDK and {
				statusCode = p4.status,
				tokenAuthBody = p4.tokenAuthBody,
				errMessageKey = v8[p2][p4.status] or v9[p2]
			} or nil)
		end)
	end))
end

v10.default = v10.new()

return v10
