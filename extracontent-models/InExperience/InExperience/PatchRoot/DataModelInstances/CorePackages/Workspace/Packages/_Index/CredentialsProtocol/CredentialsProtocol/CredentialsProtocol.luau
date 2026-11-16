local HttpService = game:GetService("HttpService")

local parent = script.Parent.Parent

local MessageBus = require(parent.MessageBus)
local messageBus = MessageBus.MessageBus
local t = require(parent.t)
local Promise = require(parent.Promise)

require(script.Parent.CredentialsProtocolTypes)
local Constants = require(script.Parent.Constants)
local normalizeUnifiedGetCredentialsResponse = require(script.Parent.normalizeUnifiedGetCredentialsResponse)

local FFlagLuaAppNormalizeUnifiedPasskeyResponse = require(script.Parent.Flags.FFlagLuaAppNormalizeUnifiedPasskeyResponse)

local FFlagCacheCredentialsProtocolIsAvailable = require(script.Parent.Flags.FFlagCacheCredentialsProtocolIsAvailable)

local CredentialsTypes = Constants.CredentialsTypes

local function isNativeIsAvailableReply(data): boolean -- 1 equivalent call inferred from this helper
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

local v = {
	[CredentialsTypes.FIDO2] = t.strictInterface({
		credentialType = t.string,
		parameters = strictInterface
	}),
	[CredentialsTypes.all] = t.strictInterface({
		FIDO2 = t.optional(strictInterface),
		password = t.optional(t.strictInterface({ username = t.optional(t.string) }))
	}),
	[CredentialsTypes.iosKeychainPassword] = t.strictInterface({
		credentialType = t.string,
		parameters = t.interface({ server = t.optional(t.string) })
	}),
	[CredentialsTypes.keystore] = t.strictInterface({
		credentialType = t.string,
		parameters = t.interface({ server = t.optional(t.string), key = t.optional(t.string) })
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

local v2 = { [CredentialsTypes.FIDO2] = strictInterface2 }
local all = CredentialsTypes.all

if FFlagLuaAppNormalizeUnifiedPasskeyResponse then
	strictInterface3 = t.union(strictInterface3, strictInterface2)
end

v2[all] = strictInterface3

v2[CredentialsTypes.iosKeychainPassword] = t.array(t.strictInterface({
	experimentGroup = t.optional(t.string),
	username = t.optional(t.string),
	userId = t.optional(t.string),
	password = t.optional(t.string),
	errorCode = t.optional(t.string),
	errorMsg = t.optional(t.string)
}))

v2[CredentialsTypes.keystore] = t.array(t.strictInterface({
	experimentGroup = t.optional(t.string),
	username = t.optional(t.string),
	userId = t.optional(t.string),
	password = t.optional(t.string),
	errorCode = t.optional(t.string),
	errorMsg = t.optional(t.string)
}))

local v3 = {
	[CredentialsTypes.FIDO2] = t.strictInterface({
		credentialType = t.string,
		parameters = t.interface({
			keyType = t.optional(t.string),
			isSilentPasskeyUpgrade = t.optional(t.boolean),
			publicKey = t.interface({
				rp = t.interface({ name = t.string, id = t.string }),
				user = t.interface({ name = t.string, displayName = t.string, id = t.string }),
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
	[CredentialsTypes.password] = t.strictInterface({
		credentialType = t.string,
		parameters = t.strictInterface({ username = t.string, password = t.string })
	}),
	[CredentialsTypes.iosKeychainPassword] = t.strictInterface({
		credentialType = t.string,
		parameters = t.strictInterface({
			server = t.string,
			username = t.string,
			userId = t.string,
			password = t.string,
			experimentGroup = t.optional(t.string)
		})
	}),
	[CredentialsTypes.keystore] = t.strictInterface({
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

local v4 = {
	[CredentialsTypes.FIDO2] = t.strictInterface({
		id = t.optional(t.string),
		rawId = t.optional(t.string),
		type = t.optional(t.string),
		response = t.interface({ clientDataJSON = t.string, attestationObject = t.string }),
		authenticatorAttachment = t.optional(t.string),
		clientExtensionResults = t.optional(t.table),
		errorCode = t.optional(t.string),
		errorMsg = t.optional(t.string)
	}),
	[CredentialsTypes.password] = t.strictInterface({
		errorCode = t.optional(t.string),
		errorMsg = t.optional(t.string)
	}),
	[CredentialsTypes.iosKeychainPassword] = t.strictInterface({
		errorCode = t.optional(t.string),
		errorMsg = t.optional(t.string)
	}),
	[CredentialsTypes.keystore] = t.strictInterface({
		errorCode = t.optional(t.string),
		errorMsg = t.optional(t.string)
	})
}

local CredentialsProtocol = {
	CredentialsTypes = CredentialsTypes,
	GET_CREDENTIALS_REQUEST_DESCRIPTOR = {
		[CredentialsTypes.FIDO2] = {
			mid = messageBus.getMessageId("Credentials", "getCredentialsRequest"),
			validateParams = v[CredentialsTypes.FIDO2]
		},
		[CredentialsTypes.all] = {
			mid = messageBus.getMessageId("Credentials", "getCredentialsRequest"),
			validateParams = v[CredentialsTypes.all]
		},
		[CredentialsTypes.iosKeychainPassword] = {
			mid = messageBus.getMessageId("Credentials", "getCredentialsRequest"),
			validateParams = v[CredentialsTypes.iosKeychainPassword]
		},
		[CredentialsTypes.keystore] = {
			mid = messageBus.getMessageId("Credentials", "getCredentialsRequest"),
			validateParams = v[CredentialsTypes.keystore]
		}
	},
	GET_CREDENTIALS_RESPONSE_DESCRIPTOR = {
		[CredentialsTypes.FIDO2] = {
			mid = messageBus.getMessageId("Credentials", "getCredentialsResponse"),
			validateParams = v2[CredentialsTypes.FIDO2]
		},
		[CredentialsTypes.all] = {
			mid = messageBus.getMessageId("Credentials", "getCredentialsResponse"),
			validateParams = v2[CredentialsTypes.all]
		},
		[CredentialsTypes.iosKeychainPassword] = {
			mid = messageBus.getMessageId("Credentials", "getCredentialsResponse"),
			validateParams = v2[CredentialsTypes.iosKeychainPassword]
		},
		[CredentialsTypes.keystore] = {
			mid = messageBus.getMessageId("Credentials", "getCredentialsResponse"),
			validateParams = v2[CredentialsTypes.keystore]
		}
	},
	DELETE_IOS_KEYCHAIN_CREDENTIALS_REQUEST_DESCRIPTOR = {
		[CredentialsTypes.iosKeychainPassword] = {
			mid = messageBus.getMessageId("Credentials", "deleteIosKeychainCredentialsRequest"),
			validateParams = t.strictInterface({
				credentialType = t.string,
				parameters = t.strictInterface({ server = t.string })
			})
		}
	},
	DELETE_KEYSTORE_CREDENTIALS_REQUEST_DESCRIPTOR = {
		[CredentialsTypes.keystore] = {
			mid = messageBus.getMessageId("Credentials", "deleteKeystoreCredentialsRequest"),
			validateParams = t.strictInterface({
				credentialType = t.string,
				parameters = t.strictInterface({ server = t.string, key = t.optional(t.string) })
			})
		}
	},
	DELETE_IOS_KEYCHAIN_CREDENTIALS_RESPONSE_DESCRIPTOR = {
		[CredentialsTypes.iosKeychainPassword] = {
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
		[CredentialsTypes.keystore] = {
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
		[CredentialsTypes.FIDO2] = {
			mid = messageBus.getMessageId("Credentials", "registerCredentialsRequest"),
			validateParams = v3[CredentialsTypes.FIDO2]
		},
		[CredentialsTypes.password] = {
			mid = messageBus.getMessageId("Credentials", "registerCredentialsRequest"),
			validateParams = v3[CredentialsTypes.password]
		},
		[CredentialsTypes.iosKeychainPassword] = {
			mid = messageBus.getMessageId("Credentials", "registerCredentialsRequest"),
			validateParams = v3[CredentialsTypes.iosKeychainPassword]
		},
		[CredentialsTypes.keystore] = {
			mid = messageBus.getMessageId("Credentials", "registerCredentialsRequest"),
			validateParams = v3[CredentialsTypes.keystore]
		}
	},
	REGISTER_CREDENTIALS_RESPONSE_DESCRIPTOR = {
		[CredentialsTypes.FIDO2] = {
			mid = messageBus.getMessageId("Credentials", "registerCredentialsResponse"),
			validateParams = v4[CredentialsTypes.FIDO2]
		},
		[CredentialsTypes.password] = {
			mid = messageBus.getMessageId("Credentials", "registerCredentialsResponse"),
			validateParams = v4[CredentialsTypes.password]
		},
		[CredentialsTypes.iosKeychainPassword] = {
			mid = messageBus.getMessageId("Credentials", "registerCredentialsResponse"),
			validateParams = v4[CredentialsTypes.iosKeychainPassword]
		},
		[CredentialsTypes.keystore] = {
			mid = messageBus.getMessageId("Credentials", "registerCredentialsResponse"),
			validateParams = v4[CredentialsTypes.keystore]
		}
	},
	IS_AVAILABLE_REQUEST_DESCRIPTOR = {
		mid = messageBus.getMessageId("Credentials", "isAvailableRequest"),
		validateParams = t.strictInterface({
			credentialType = t.optional(t.valueOf(CredentialsTypes))
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
			password = t.optional(t.strictInterface({ isAvailable = t.boolean })),
			iosKeychainPassword = t.optional(t.strictInterface({ isAvailable = t.boolean })),
			keystore = t.optional(t.strictInterface({ isAvailable = t.boolean }))
		})
	}
}

CredentialsProtocol.__index = CredentialsProtocol

function CredentialsProtocol.new()
	return (setmetatable({
		subscriber = messageBus.Subscriber.new(),
		getCredentialsRequestInFlight = false,
		registerCredentialsRequestInFlight = false,
		deleteIosKeychainCredentialsRequestInFlight = false,
		deleteKeystoreCredentialsRequestInFlight = false
	}, CredentialsProtocol))
end

function CredentialsProtocol:getCredentials(credentialType: string, json: string, p: number)
	if self.getCredentialsRequestInFlight then
		return Promise.reject()
	end

	local race = Promise.race({
		Promise.new(function(callback, _)
			self.subscriber:subscribe(self.GET_CREDENTIALS_RESPONSE_DESCRIPTOR[credentialType], function(p2)
				self.subscriber:unsubscribe(self.GET_CREDENTIALS_RESPONSE_DESCRIPTOR[credentialType])
				self.getCredentialsRequestInFlight = false

				if FFlagLuaAppNormalizeUnifiedPasskeyResponse and credentialType == CredentialsTypes.all then
					p2 = normalizeUnifiedGetCredentialsResponse(p2)
				end

				callback((HttpService:JSONEncode(p2)))
			end)
		end),
		Promise.delay(p):andThen(function()
			self.subscriber:unsubscribe(self.GET_CREDENTIALS_RESPONSE_DESCRIPTOR[credentialType])
			self.getCredentialsRequestInFlight = false
		end)
	})

	self.getCredentialsRequestInFlight = true

	if credentialType == CredentialsTypes.all then
		messageBus.publish(self.GET_CREDENTIALS_REQUEST_DESCRIPTOR[credentialType], HttpService:JSONDecode(json))
		return race
	end

	messageBus.publish(self.GET_CREDENTIALS_REQUEST_DESCRIPTOR[credentialType], {
		credentialType = credentialType,
		parameters = HttpService:JSONDecode(json)
	})

	return race
end

function CredentialsProtocol:registerCredentials(credentialType: string, json: string, p: number)
	if self.registerCredentialsRequestInFlight then
		return Promise.reject()
	end

	local race = Promise.race({
		Promise.new(function(callback, _)
			self.subscriber:subscribe(self.REGISTER_CREDENTIALS_RESPONSE_DESCRIPTOR[credentialType], function(p2)
				self.subscriber:unsubscribe(self.REGISTER_CREDENTIALS_RESPONSE_DESCRIPTOR[credentialType])
				self.registerCredentialsRequestInFlight = false
				callback((HttpService:JSONEncode(p2)))
			end)
		end),
		Promise.delay(p):andThen(function()
			self.subscriber:unsubscribe(self.REGISTER_CREDENTIALS_RESPONSE_DESCRIPTOR[credentialType])
			self.registerCredentialsRequestInFlight = false
		end)
	})

	self.registerCredentialsRequestInFlight = true
	messageBus.publish(self.REGISTER_CREDENTIALS_REQUEST_DESCRIPTOR[credentialType], {
		credentialType = credentialType,
		parameters = HttpService:JSONDecode(json)
	})

	return race
end

function CredentialsProtocol:deleteAllCredentialsFromiOSKeychain(credentialType: string, json: string, p: number)
	if self.deleteIosKeychainCredentialsRequestInFlight then
		return Promise.reject()
	end

	local race = Promise.race({
		Promise.new(function(callback, _)
			self.subscriber:subscribe(
				self.DELETE_IOS_KEYCHAIN_CREDENTIALS_RESPONSE_DESCRIPTOR[credentialType],
				function(p2)
					self.subscriber:unsubscribe(self.DELETE_IOS_KEYCHAIN_CREDENTIALS_RESPONSE_DESCRIPTOR[credentialType])
					self.deleteIosKeychainCredentialsRequestInFlight = false
					callback((HttpService:JSONEncode(p2)))
				end
			)
		end),
		Promise.delay(p):andThen(function()
			self.subscriber:unsubscribe(self.DELETE_IOS_KEYCHAIN_CREDENTIALS_RESPONSE_DESCRIPTOR[credentialType])
			self.deleteIosKeychainCredentialsRequestInFlight = false
		end)
	})

	self.deleteIosKeychainCredentialsRequestInFlight = true

	messageBus.publish(self.DELETE_IOS_KEYCHAIN_CREDENTIALS_REQUEST_DESCRIPTOR[credentialType], {
		credentialType = credentialType,
		parameters = HttpService:JSONDecode(json)
	})

	return race
end

function CredentialsProtocol:deleteAllCredentialsFromKeystore(credentialType: string, json: string, p: number)
	if self.deleteKeystoreCredentialsRequestInFlight then
		return Promise.reject()
	end

	local race = Promise.race({
		Promise.new(function(callback, _)
			self.subscriber:subscribe(self.DELETE_KEYSTORE_CREDENTIALS_RESPONSE_DESCRIPTOR[credentialType], function(p2)
				self.subscriber:unsubscribe(self.DELETE_KEYSTORE_CREDENTIALS_RESPONSE_DESCRIPTOR[credentialType])
				self.deleteKeystoreCredentialsRequestInFlight = false
				callback((HttpService:JSONEncode(p2)))
			end)
		end),
		Promise.delay(p):andThen(function()
			self.subscriber:unsubscribe(self.DELETE_KEYSTORE_CREDENTIALS_RESPONSE_DESCRIPTOR[credentialType])
			self.deleteKeystoreCredentialsRequestInFlight = false
		end)
	})

	self.deleteKeystoreCredentialsRequestInFlight = true

	messageBus.publish(self.DELETE_KEYSTORE_CREDENTIALS_REQUEST_DESCRIPTOR[credentialType], {
		credentialType = credentialType,
		parameters = HttpService:JSONDecode(json)
	})

	return race
end

function CredentialsProtocol:sendIsAvailableRequest(credentialType: string, p: number)
	local race = Promise.race({
		Promise.new(function(callback, _)
			self.subscriber:subscribe(self.IS_AVAILABLE_RESPONSE_DESCRIPTOR, function(p2)
				self.subscriber:unsubscribe(self.IS_AVAILABLE_RESPONSE_DESCRIPTOR)
				callback(p2)
			end)
		end),
		Promise.delay(p):andThen(function()
			self.subscriber:unsubscribe(self.IS_AVAILABLE_RESPONSE_DESCRIPTOR)

			return Promise.resolve({ isAvailable = nil, supportsDeviceBoundOnly = nil })
		end)
	})

	messageBus.publish(self.IS_AVAILABLE_REQUEST_DESCRIPTOR, { credentialType = credentialType })

	return race
end

function CredentialsProtocol:isAvailable(p: string, p2: number)
	if not FFlagCacheCredentialsProtocolIsAvailable then
		return self:sendIsAvailableRequest(p, p2)
	end

	local isAvailableCache = self.isAvailableCache

	if isAvailableCache ~= nil and os.clock() - isAvailableCache.clock < 30 then
		return Promise.resolve(isAvailableCache.result)
	end

	if self.isAvailableRequest ~= nil then
		return self.isAvailableRequest
	end

	local isAvailableRequest = self:sendIsAvailableRequest(p, p2)
	self.isAvailableRequest = isAvailableRequest

	return isAvailableRequest:andThen(function(data)
		self.isAvailableRequest = nil

		if isNativeIsAvailableReply(data) then -- inferred equivalent call
			self.isAvailableCache = { result = data, clock = os.clock() }
		end

		return data
	end):catch(function(p3)
		self.isAvailableRequest = nil
		return Promise.reject(p3)
	end)
end

CredentialsProtocol.default = CredentialsProtocol.new()

return CredentialsProtocol
