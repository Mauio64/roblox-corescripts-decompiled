local HttpService = game:GetService("HttpService")

local messageBus = require("@game/CorePackages/Workspace/Packages/_Workspace/CredentialsProtocol/MessageBus").MessageBus
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/CredentialsProtocol/t")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/CredentialsProtocol/Promise")

require("@game/CorePackages/Workspace/Packages/_Index/CredentialsProtocol/CredentialsProtocol/CredentialsProtocolTypes")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/CredentialsProtocol/CredentialsProtocol/Constants")
local normalizeUnifiedGetCredentialsResponse = require("@game/CorePackages/Workspace/Packages/_Index/CredentialsProtocol/CredentialsProtocol/normalizeUnifiedGetCredentialsResponse")

local FFlagLuaAppNormalizeUnifiedPasskeyResponse = require("@game/CorePackages/Workspace/Packages/_Index/CredentialsProtocol/CredentialsProtocol/Flags/FFlagLuaAppNormalizeUnifiedPasskeyResponse")

local FFlagCacheCredentialsProtocolIsAvailable = require("@game/CorePackages/Workspace/Packages/_Index/CredentialsProtocol/CredentialsProtocol/Flags/FFlagCacheCredentialsProtocolIsAvailable")

local credentialsTypes = Constants.CredentialsTypes

local function isNativeIsAvailableReply(data): boolean
	return data.isAvailable ~= nil
		or data.FIDO2 ~= nil
		or data.password ~= nil
		or data.iosKeychainPassword ~= nil
		or data.keystore ~= nil
end

local strictInterface = t.strictInterface({
	keyType = t.optional(t.string),
	publicKey = t.interface({
		challenge = t.string,
		timeout = t.optional(t.number),
		rpId = t.optional(t.string),
		allowCredentials = t.optional(t.table),
		userVerification = t.optional(t.string),
		attestation = t.optional(t.string),
		extensions = t.optional(t.table)
	}),
	deviceBoundOnly = t.optional(t.boolean)
})

local v5 = {
	[credentialsTypes.FIDO2] = t.strictInterface({
		credentialType = t.string,
		parameters = strictInterface
	}),
	[credentialsTypes.all] = t.strictInterface({
		FIDO2 = t.optional(strictInterface),
		password = t.optional(t.strictInterface({
			username = t.optional(t.string)
		}))
	}),
	[credentialsTypes.iosKeychainPassword] = t.strictInterface({
		credentialType = t.string,
		parameters = t.interface({ server = t.optional(t.string) })
	}),
	[credentialsTypes.keystore] = t.strictInterface({
		credentialType = t.string,
		parameters = t.interface({
			server = t.optional(t.string),
			key = t.optional(t.string)
		})
	})
}

local strictInterface2 = t.strictInterface({
	id = t.optional(t.string),
	rawId = t.optional(t.string),
	type = t.optional(t.string),
	response = t.interface({
		authenticatorData = t.string,
		clientDataJSON = t.string,
		signature = t.string,
		userHandle = t.optional(t.string)
	}),
	errorCode = t.optional(t.string),
	errorMsg = t.optional(t.string)
})

local strictInterface3 = t.strictInterface({
	credentialType = t.string,
	response = t.union(
		strictInterface2,
		t.strictInterface({
			username = t.optional(t.string),
			password = t.optional(t.string),
			errorCode = t.optional(t.string),
			errorMsg = t.optional(t.string)
		})
	)
})

local v6 = { [credentialsTypes.FIDO2] = strictInterface2 }
local all = credentialsTypes.all

if FFlagLuaAppNormalizeUnifiedPasskeyResponse then
	strictInterface3 = t.union(strictInterface3, strictInterface2)
end

v6[all] = strictInterface3

v6[credentialsTypes.iosKeychainPassword] = t.array(t.strictInterface({
	experimentGroup = t.optional(t.string),
	username = t.optional(t.string),
	userId = t.optional(t.string),
	password = t.optional(t.string),
	errorCode = t.optional(t.string),
	errorMsg = t.optional(t.string)
}))

v6[credentialsTypes.keystore] = t.array(t.strictInterface({
	experimentGroup = t.optional(t.string),
	username = t.optional(t.string),
	userId = t.optional(t.string),
	password = t.optional(t.string),
	errorCode = t.optional(t.string),
	errorMsg = t.optional(t.string)
}))

local v7 = {
	[credentialsTypes.FIDO2] = t.strictInterface({
		credentialType = t.string,
		parameters = t.interface({
			keyType = t.optional(t.string),
			isSilentPasskeyUpgrade = t.optional(t.boolean),
			publicKey = t.interface({
				rp = t.interface({ name = t.string, id = t.string }),
				user = t.interface({
					name = t.string,
					displayName = t.string,
					id = t.string
				}),
				challenge = t.string,
				pubKeyCredParams = t.optional(t.table),
				timeout = t.optional(t.number),
				excludeCredentials = t.optional(t.table),
				authenticationSelection = t.optional(t.table),
				attestation = t.optional(t.string),
				extensions = t.optional(t.table)
			})
		})
	}),
	[credentialsTypes.password] = t.strictInterface({
		credentialType = t.string,
		parameters = t.strictInterface({
			username = t.string,
			password = t.string
		})
	}),
	[credentialsTypes.iosKeychainPassword] = t.strictInterface({
		credentialType = t.string,
		parameters = t.strictInterface({
			server = t.string,
			username = t.string,
			userId = t.string,
			password = t.string,
			experimentGroup = t.optional(t.string)
		})
	}),
	[credentialsTypes.keystore] = t.strictInterface({
		credentialType = t.string,
		parameters = t.strictInterface({
			server = t.string,
			key = t.optional(t.string),
			username = t.string,
			userId = t.string,
			password = t.string,
			experimentGroup = t.optional(t.string)
		})
	})
}

local v8 = {
	[credentialsTypes.FIDO2] = t.strictInterface({
		id = t.optional(t.string),
		rawId = t.optional(t.string),
		type = t.optional(t.string),
		response = t.interface({
			clientDataJSON = t.string,
			attestationObject = t.string
		}),
		authenticatorAttachment = t.optional(t.string),
		clientExtensionResults = t.optional(t.table),
		errorCode = t.optional(t.string),
		errorMsg = t.optional(t.string)
	}),
	[credentialsTypes.password] = t.strictInterface({
		errorCode = t.optional(t.string),
		errorMsg = t.optional(t.string)
	}),
	[credentialsTypes.iosKeychainPassword] = t.strictInterface({
		errorCode = t.optional(t.string),
		errorMsg = t.optional(t.string)
	}),
	[credentialsTypes.keystore] = t.strictInterface({
		errorCode = t.optional(t.string),
		errorMsg = t.optional(t.string)
	})
}

local v9 = {
	CredentialsTypes = credentialsTypes,
	GET_CREDENTIALS_REQUEST_DESCRIPTOR = {
		[credentialsTypes.FIDO2] = {
			mid = messageBus.getMessageId("Credentials", "getCredentialsRequest"),
			validateParams = v5[credentialsTypes.FIDO2]
		},
		[credentialsTypes.all] = {
			mid = messageBus.getMessageId("Credentials", "getCredentialsRequest"),
			validateParams = v5[credentialsTypes.all]
		},
		[credentialsTypes.iosKeychainPassword] = {
			mid = messageBus.getMessageId("Credentials", "getCredentialsRequest"),
			validateParams = v5[credentialsTypes.iosKeychainPassword]
		},
		[credentialsTypes.keystore] = {
			mid = messageBus.getMessageId("Credentials", "getCredentialsRequest"),
			validateParams = v5[credentialsTypes.keystore]
		}
	},
	GET_CREDENTIALS_RESPONSE_DESCRIPTOR = {
		[credentialsTypes.FIDO2] = {
			mid = messageBus.getMessageId("Credentials", "getCredentialsResponse"),
			validateParams = v6[credentialsTypes.FIDO2]
		},
		[credentialsTypes.all] = {
			mid = messageBus.getMessageId("Credentials", "getCredentialsResponse"),
			validateParams = v6[credentialsTypes.all]
		},
		[credentialsTypes.iosKeychainPassword] = {
			mid = messageBus.getMessageId("Credentials", "getCredentialsResponse"),
			validateParams = v6[credentialsTypes.iosKeychainPassword]
		},
		[credentialsTypes.keystore] = {
			mid = messageBus.getMessageId("Credentials", "getCredentialsResponse"),
			validateParams = v6[credentialsTypes.keystore]
		}
	},
	DELETE_IOS_KEYCHAIN_CREDENTIALS_REQUEST_DESCRIPTOR = {
		[credentialsTypes.iosKeychainPassword] = {
			mid = messageBus.getMessageId("Credentials", "deleteIosKeychainCredentialsRequest"),
			validateParams = t.strictInterface({
				credentialType = t.string,
				parameters = t.strictInterface({ server = t.string })
			})
		}
	},
	DELETE_KEYSTORE_CREDENTIALS_REQUEST_DESCRIPTOR = {
		[credentialsTypes.keystore] = {
			mid = messageBus.getMessageId("Credentials", "deleteKeystoreCredentialsRequest"),
			validateParams = t.strictInterface({
				credentialType = t.string,
				parameters = t.strictInterface({
					server = t.string,
					key = t.optional(t.string)
				})
			})
		}
	},
	DELETE_IOS_KEYCHAIN_CREDENTIALS_RESPONSE_DESCRIPTOR = {
		[credentialsTypes.iosKeychainPassword] = {
			mid = messageBus.getMessageId("Credentials", "deleteIosKeychainCredentialsResponse"),
			validateParams = t.strictInterface({
				credentialType = t.string,
				response = t.array(t.strictInterface({
					errorCode = t.optional(t.string),
					errorMsg = t.optional(t.string)
				}))
			})
		}
	},
	DELETE_KEYSTORE_CREDENTIALS_RESPONSE_DESCRIPTOR = {
		[credentialsTypes.keystore] = {
			mid = messageBus.getMessageId("Credentials", "deleteKeystoreCredentialsResponse"),
			validateParams = t.strictInterface({
				credentialType = t.string,
				response = t.array(t.strictInterface({
					errorCode = t.optional(t.string),
					errorMsg = t.optional(t.string)
				}))
			})
		}
	},
	REGISTER_CREDENTIALS_REQUEST_DESCRIPTOR = {
		[credentialsTypes.FIDO2] = {
			mid = messageBus.getMessageId("Credentials", "registerCredentialsRequest"),
			validateParams = v7[credentialsTypes.FIDO2]
		},
		[credentialsTypes.password] = {
			mid = messageBus.getMessageId("Credentials", "registerCredentialsRequest"),
			validateParams = v7[credentialsTypes.password]
		},
		[credentialsTypes.iosKeychainPassword] = {
			mid = messageBus.getMessageId("Credentials", "registerCredentialsRequest"),
			validateParams = v7[credentialsTypes.iosKeychainPassword]
		},
		[credentialsTypes.keystore] = {
			mid = messageBus.getMessageId("Credentials", "registerCredentialsRequest"),
			validateParams = v7[credentialsTypes.keystore]
		}
	},
	REGISTER_CREDENTIALS_RESPONSE_DESCRIPTOR = {
		[credentialsTypes.FIDO2] = {
			mid = messageBus.getMessageId("Credentials", "registerCredentialsResponse"),
			validateParams = v8[credentialsTypes.FIDO2]
		},
		[credentialsTypes.password] = {
			mid = messageBus.getMessageId("Credentials", "registerCredentialsResponse"),
			validateParams = v8[credentialsTypes.password]
		},
		[credentialsTypes.iosKeychainPassword] = {
			mid = messageBus.getMessageId("Credentials", "registerCredentialsResponse"),
			validateParams = v8[credentialsTypes.iosKeychainPassword]
		},
		[credentialsTypes.keystore] = {
			mid = messageBus.getMessageId("Credentials", "registerCredentialsResponse"),
			validateParams = v8[credentialsTypes.keystore]
		}
	},
	IS_AVAILABLE_REQUEST_DESCRIPTOR = {
		mid = messageBus.getMessageId("Credentials", "isAvailableRequest"),
		validateParams = t.strictInterface({
			credentialType = t.optional(t.valueOf(credentialsTypes))
		})
	},
	IS_AVAILABLE_RESPONSE_DESCRIPTOR = {
		mid = messageBus.getMessageId("Credentials", "isAvailableResponse"),
		validateParams = t.strictInterface({
			isAvailable = t.optional(t.boolean),
			supportsDeviceBoundOnly = t.optional(t.boolean),
			FIDO2 = t.optional(t.strictInterface({
				isAvailable = t.boolean,
				supportsDeviceBoundOnly = t.boolean,
				supportsSilentPasskeyUpgrade = t.optional(t.boolean),
				supportsPasskeyCreationOnDevice = t.optional(t.boolean)
			})),
			password = t.optional(t.strictInterface({
				isAvailable = t.boolean
			})),
			iosKeychainPassword = t.optional(t.strictInterface({
				isAvailable = t.boolean
			})),
			keystore = t.optional(t.strictInterface({
				isAvailable = t.boolean
			}))
		})
	}
}

v9.__index = v9

function v9.new()
	return (setmetatable({
		subscriber = messageBus.Subscriber.new(),
		getCredentialsRequestInFlight = false,
		registerCredentialsRequestInFlight = false,
		deleteIosKeychainCredentialsRequestInFlight = false,
		deleteKeystoreCredentialsRequestInFlight = false
	}, v9))
end

function v9:getCredentials(p2, json, p3)
	if self.getCredentialsRequestInFlight then
		return Promise.reject()
	end

	local race = Promise.race({
		Promise.new(function(callback, p4)
			self.subscriber:subscribe(self.GET_CREDENTIALS_RESPONSE_DESCRIPTOR[p2], function(p5)
				self.subscriber:unsubscribe(self.GET_CREDENTIALS_RESPONSE_DESCRIPTOR[p2])
				self.getCredentialsRequestInFlight = false

				if FFlagLuaAppNormalizeUnifiedPasskeyResponse and p2 == credentialsTypes.all then
					p5 = normalizeUnifiedGetCredentialsResponse(p5)
				end

				callback((HttpService:JSONEncode(p5)))
			end)
		end),
		Promise.delay(p3):andThen(function()
			self.subscriber:unsubscribe(self.GET_CREDENTIALS_RESPONSE_DESCRIPTOR[p2])
			self.getCredentialsRequestInFlight = false
		end)
	})

	self.getCredentialsRequestInFlight = true

	if p2 == credentialsTypes.all then
		messageBus.publish(self.GET_CREDENTIALS_REQUEST_DESCRIPTOR[p2], HttpService:JSONDecode(json))
		return race
	end

	messageBus.publish(self.GET_CREDENTIALS_REQUEST_DESCRIPTOR[p2], {
		credentialType = p2,
		parameters = HttpService:JSONDecode(json)
	})

	return race
end

function v9:registerCredentials(p2, json, p3)
	if self.registerCredentialsRequestInFlight then
		return Promise.reject()
	end

	local race = Promise.race({
		Promise.new(function(callback, p4)
			self.subscriber:subscribe(self.REGISTER_CREDENTIALS_RESPONSE_DESCRIPTOR[p2], function(p5)
				self.subscriber:unsubscribe(self.REGISTER_CREDENTIALS_RESPONSE_DESCRIPTOR[p2])
				self.registerCredentialsRequestInFlight = false
				callback((HttpService:JSONEncode(p5)))
			end)
		end),
		Promise.delay(p3):andThen(function()
			self.subscriber:unsubscribe(self.REGISTER_CREDENTIALS_RESPONSE_DESCRIPTOR[p2])
			self.registerCredentialsRequestInFlight = false
		end)
	})

	self.registerCredentialsRequestInFlight = true
	messageBus.publish(self.REGISTER_CREDENTIALS_REQUEST_DESCRIPTOR[p2], {
		credentialType = p2,
		parameters = HttpService:JSONDecode(json)
	})

	return race
end

function v9:deleteAllCredentialsFromiOSKeychain(p2, json, p3)
	if self.deleteIosKeychainCredentialsRequestInFlight then
		return Promise.reject()
	end

	local race = Promise.race({
		Promise.new(function(callback, p4)
			self.subscriber:subscribe(
				self.DELETE_IOS_KEYCHAIN_CREDENTIALS_RESPONSE_DESCRIPTOR[p2],
				function(p5)
					self.subscriber:unsubscribe(self.DELETE_IOS_KEYCHAIN_CREDENTIALS_RESPONSE_DESCRIPTOR[p2])
					self.deleteIosKeychainCredentialsRequestInFlight = false
					callback((HttpService:JSONEncode(p5)))
				end
			)
		end),
		Promise.delay(p3):andThen(function()
			self.subscriber:unsubscribe(self.DELETE_IOS_KEYCHAIN_CREDENTIALS_RESPONSE_DESCRIPTOR[p2])
			self.deleteIosKeychainCredentialsRequestInFlight = false
		end)
	})

	self.deleteIosKeychainCredentialsRequestInFlight = true

	messageBus.publish(self.DELETE_IOS_KEYCHAIN_CREDENTIALS_REQUEST_DESCRIPTOR[p2], {
		credentialType = p2,
		parameters = HttpService:JSONDecode(json)
	})

	return race
end

function v9:deleteAllCredentialsFromKeystore(p2, json, p3)
	if self.deleteKeystoreCredentialsRequestInFlight then
		return Promise.reject()
	end

	local race = Promise.race({
		Promise.new(function(callback, p4)
			self.subscriber:subscribe(self.DELETE_KEYSTORE_CREDENTIALS_RESPONSE_DESCRIPTOR[p2], function(p5)
				self.subscriber:unsubscribe(self.DELETE_KEYSTORE_CREDENTIALS_RESPONSE_DESCRIPTOR[p2])
				self.deleteKeystoreCredentialsRequestInFlight = false
				callback((HttpService:JSONEncode(p5)))
			end)
		end),
		Promise.delay(p3):andThen(function()
			self.subscriber:unsubscribe(self.DELETE_KEYSTORE_CREDENTIALS_RESPONSE_DESCRIPTOR[p2])
			self.deleteKeystoreCredentialsRequestInFlight = false
		end)
	})

	self.deleteKeystoreCredentialsRequestInFlight = true

	messageBus.publish(self.DELETE_KEYSTORE_CREDENTIALS_REQUEST_DESCRIPTOR[p2], {
		credentialType = p2,
		parameters = HttpService:JSONDecode(json)
	})

	return race
end

function v9:sendIsAvailableRequest(p2, p3)
	local race = Promise.race({
		Promise.new(function(callback, p4)
			self.subscriber:subscribe(self.IS_AVAILABLE_RESPONSE_DESCRIPTOR, function(p5)
				self.subscriber:unsubscribe(self.IS_AVAILABLE_RESPONSE_DESCRIPTOR)
				callback(p5)
			end)
		end),
		Promise.delay(p3):andThen(function()
			self.subscriber:unsubscribe(self.IS_AVAILABLE_RESPONSE_DESCRIPTOR)

			return Promise.resolve({ isAvailable = nil, supportsDeviceBoundOnly = nil })
		end)
	})

	messageBus.publish(self.IS_AVAILABLE_REQUEST_DESCRIPTOR, { credentialType = p2 })

	return race
end

function v9:isAvailable(p2, p3)
	if not FFlagCacheCredentialsProtocolIsAvailable then
		return self:sendIsAvailableRequest(p2, p3)
	end

	local isAvailableCache = self.isAvailableCache

	if isAvailableCache ~= nil and os.clock() - isAvailableCache.clock < 30 then
		return Promise.resolve(isAvailableCache.result)
	end

	if self.isAvailableRequest ~= nil then
		return self.isAvailableRequest
	end

	local v18 = self:sendIsAvailableRequest(p2, p3)
	self.isAvailableRequest = v18

	return v18:andThen(function(data)
		self.isAvailableRequest = nil

		if
			data.isAvailable ~= nil
			or data.FIDO2 ~= nil
			or data.password ~= nil
			or data.iosKeychainPassword ~= nil
			or data.keystore ~= nil
		then
			self.isAvailableCache = { result = data, clock = os.clock() }
		end

		return data
	end):catch(function(p4)
		self.isAvailableRequest = nil
		return Promise.reject(p4)
	end)
end

v9.default = v9.new()

return v9
