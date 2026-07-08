local HttpService = game:GetService("HttpService")
local ParentParent = script.Parent.Parent
local MessageBus = require(ParentParent.MessageBus).MessageBus
local t = require(ParentParent.t)
local Promise = require(ParentParent.Promise)

require(script.Parent.CredentialsProtocolTypes)

local t1 = {
	FIDO2 = "FIDO2",
	password = "password",
	all = "all",
	iosKeychainPassword = "iosKeychainPassword",
	keystore = "keystore"
}
local v7 = t.strictInterface({
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
local t2 = {
	[t1.FIDO2] = t.strictInterface({
		credentialType = t.string,
		parameters = v7
	}),
	[t1.all] = t.strictInterface({
		FIDO2 = t.optional(v7),
		password = t.optional(t.strictInterface({
			username = t.optional(t.string)
		}))
	}),
	[t1.iosKeychainPassword] = t.strictInterface({
		credentialType = t.string,
		parameters = t.interface({
			server = t.optional(t.string)
		})
	}),
	[t1.keystore] = t.strictInterface({
		credentialType = t.string,
		parameters = t.interface({
			server = t.optional(t.string),
			key = t.optional(t.string)
		})
	})
}
local v9 = t.strictInterface({
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
local t3 = {
	[t1.FIDO2] = v9,
	[t1.all] = t.strictInterface({
		credentialType = t.string,
		response = t.union(v9, t.strictInterface({
			username = t.optional(t.string),
			password = t.optional(t.string),
			errorCode = t.optional(t.string),
			errorMsg = t.optional(t.string)
		}))
	}),
	[t1.iosKeychainPassword] = t.array(t.strictInterface({
		experimentGroup = t.optional(t.string),
		username = t.optional(t.string),
		userId = t.optional(t.string),
		password = t.optional(t.string),
		errorCode = t.optional(t.string),
		errorMsg = t.optional(t.string)
	})),
	[t1.keystore] = t.array(t.strictInterface({
		experimentGroup = t.optional(t.string),
		username = t.optional(t.string),
		userId = t.optional(t.string),
		password = t.optional(t.string),
		errorCode = t.optional(t.string),
		errorMsg = t.optional(t.string)
	}))
}
local t4 = {
	[t1.FIDO2] = t.strictInterface({
		credentialType = t.string,
		parameters = t.interface({
			keyType = t.optional(t.string),
			isSilentPasskeyUpgrade = t.optional(t.boolean),
			publicKey = t.interface({
				rp = t.interface({
					name = t.string,
					id = t.string
				}),
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
	[t1.password] = t.strictInterface({
		credentialType = t.string,
		parameters = t.strictInterface({
			username = t.string,
			password = t.string
		})
	}),
	[t1.iosKeychainPassword] = t.strictInterface({
		credentialType = t.string,
		parameters = t.strictInterface({
			server = t.string,
			username = t.string,
			userId = t.string,
			password = t.string,
			experimentGroup = t.optional(t.string)
		})
	}),
	[t1.keystore] = t.strictInterface({
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
local t5 = {
	[t1.FIDO2] = t.strictInterface({
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
	[t1.password] = t.strictInterface({
		errorCode = t.optional(t.string),
		errorMsg = t.optional(t.string)
	}),
	[t1.iosKeychainPassword] = t.strictInterface({
		errorCode = t.optional(t.string),
		errorMsg = t.optional(t.string)
	}),
	[t1.keystore] = t.strictInterface({
		errorCode = t.optional(t.string),
		errorMsg = t.optional(t.string)
	})
}
local t6 = {
	CredentialsTypes = t1,
	GET_CREDENTIALS_REQUEST_DESCRIPTOR = {
		[t1.FIDO2] = {
			mid = MessageBus.getMessageId("Credentials", "getCredentialsRequest"),
			validateParams = t2[t1.FIDO2]
		},
		[t1.all] = {
			mid = MessageBus.getMessageId("Credentials", "getCredentialsRequest"),
			validateParams = t2[t1.all]
		},
		[t1.iosKeychainPassword] = {
			mid = MessageBus.getMessageId("Credentials", "getCredentialsRequest"),
			validateParams = t2[t1.iosKeychainPassword]
		},
		[t1.keystore] = {
			mid = MessageBus.getMessageId("Credentials", "getCredentialsRequest"),
			validateParams = t2[t1.keystore]
		}
	},
	GET_CREDENTIALS_RESPONSE_DESCRIPTOR = {
		[t1.FIDO2] = {
			mid = MessageBus.getMessageId("Credentials", "getCredentialsResponse"),
			validateParams = t3[t1.FIDO2]
		},
		[t1.all] = {
			mid = MessageBus.getMessageId("Credentials", "getCredentialsResponse"),
			validateParams = t3[t1.all]
		},
		[t1.iosKeychainPassword] = {
			mid = MessageBus.getMessageId("Credentials", "getCredentialsResponse"),
			validateParams = t3[t1.iosKeychainPassword]
		},
		[t1.keystore] = {
			mid = MessageBus.getMessageId("Credentials", "getCredentialsResponse"),
			validateParams = t3[t1.keystore]
		}
	},
	DELETE_IOS_KEYCHAIN_CREDENTIALS_REQUEST_DESCRIPTOR = {
		[t1.iosKeychainPassword] = {
			mid = MessageBus.getMessageId("Credentials", "deleteIosKeychainCredentialsRequest"),
			validateParams = t.strictInterface({
				credentialType = t.string,
				parameters = t.strictInterface({
					server = t.string
				})
			})
		}
	},
	DELETE_KEYSTORE_CREDENTIALS_REQUEST_DESCRIPTOR = {
		[t1.keystore] = {
			mid = MessageBus.getMessageId("Credentials", "deleteKeystoreCredentialsRequest"),
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
		[t1.iosKeychainPassword] = {
			mid = MessageBus.getMessageId("Credentials", "deleteIosKeychainCredentialsResponse"),
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
		[t1.keystore] = {
			mid = MessageBus.getMessageId("Credentials", "deleteKeystoreCredentialsResponse"),
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
		[t1.FIDO2] = {
			mid = MessageBus.getMessageId("Credentials", "registerCredentialsRequest"),
			validateParams = t4[t1.FIDO2]
		},
		[t1.password] = {
			mid = MessageBus.getMessageId("Credentials", "registerCredentialsRequest"),
			validateParams = t4[t1.password]
		},
		[t1.iosKeychainPassword] = {
			mid = MessageBus.getMessageId("Credentials", "registerCredentialsRequest"),
			validateParams = t4[t1.iosKeychainPassword]
		},
		[t1.keystore] = {
			mid = MessageBus.getMessageId("Credentials", "registerCredentialsRequest"),
			validateParams = t4[t1.keystore]
		}
	},
	REGISTER_CREDENTIALS_RESPONSE_DESCRIPTOR = {
		[t1.FIDO2] = {
			mid = MessageBus.getMessageId("Credentials", "registerCredentialsResponse"),
			validateParams = t5[t1.FIDO2]
		},
		[t1.password] = {
			mid = MessageBus.getMessageId("Credentials", "registerCredentialsResponse"),
			validateParams = t5[t1.password]
		},
		[t1.iosKeychainPassword] = {
			mid = MessageBus.getMessageId("Credentials", "registerCredentialsResponse"),
			validateParams = t5[t1.iosKeychainPassword]
		},
		[t1.keystore] = {
			mid = MessageBus.getMessageId("Credentials", "registerCredentialsResponse"),
			validateParams = t5[t1.keystore]
		}
	},
	IS_AVAILABLE_REQUEST_DESCRIPTOR = {
		mid = MessageBus.getMessageId("Credentials", "isAvailableRequest"),
		validateParams = t.strictInterface({
			credentialType = t.optional(t.valueOf(t1))
		})
	},
	IS_AVAILABLE_RESPONSE_DESCRIPTOR = {
		mid = MessageBus.getMessageId("Credentials", "isAvailableResponse"),
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

t6.__index = t6

function t6.new() -- line: 407
	-- upvalues: MessageBus (copy), t6 (copy)
	return (setmetatable({
		getCredentialsRequestInFlight = false,
		registerCredentialsRequestInFlight = false,
		deleteIosKeychainCredentialsRequestInFlight = false,
		deleteKeystoreCredentialsRequestInFlight = false,
		subscriber = MessageBus.Subscriber.new()
	}, t6))
end
function t6.getCredentials(t7: {[any]: any}, s1: string, s2: string, n1: number) -- line: 421
	-- upvalues: Promise (copy), HttpService (copy), t1 (copy), MessageBus (copy)
	if not t7.getCredentialsRequestInFlight then
		local v18 = Promise.race({
			Promise.new(function(resolve, _) -- line: 425
				-- upvalues: t7 (copy), s1 (copy), HttpService (copy)
				t7.subscriber:subscribe(t7.GET_CREDENTIALS_RESPONSE_DESCRIPTOR[s1], function(p2) -- line: 426
					-- upvalues: t7 (copy), s1 (copy), HttpService (copy), resolve (copy)
					t7.subscriber:unsubscribe(t7.GET_CREDENTIALS_RESPONSE_DESCRIPTOR[s1])
					t7.getCredentialsRequestInFlight = false

					local json = HttpService:JSONEncode(p2)

					resolve(json)
				end)
			end),
			Promise.delay(n1):andThen(function() -- line: 433
				-- upvalues: t7 (copy), s1 (copy)
				t7.subscriber:unsubscribe(t7.GET_CREDENTIALS_RESPONSE_DESCRIPTOR[s1])
				t7.getCredentialsRequestInFlight = false
			end)
		})

		t7.getCredentialsRequestInFlight = true

		if s1 == t1.all then
			MessageBus.publish(t7.GET_CREDENTIALS_REQUEST_DESCRIPTOR[s1], HttpService:JSONDecode(s2))

			return v18
		end

		MessageBus.publish(t7.GET_CREDENTIALS_REQUEST_DESCRIPTOR[s1], {
			credentialType = s1,
			parameters = HttpService:JSONDecode(s2)
		})

		return v18
	end

	return Promise.reject()
end
function t6.registerCredentials(t8: {[any]: any}, s3: string, s4: string, n2: number) -- line: 459
	-- upvalues: Promise (copy), HttpService (copy), MessageBus (copy)
	if not t8.registerCredentialsRequestInFlight then
		local v23 = Promise.race({
			Promise.new(function(resolve, _) -- line: 467
				-- upvalues: t8 (copy), s3 (copy), HttpService (copy)
				t8.subscriber:subscribe(t8.REGISTER_CREDENTIALS_RESPONSE_DESCRIPTOR[s3], function(p4) -- line: 470
					-- upvalues: t8 (copy), s3 (copy), HttpService (copy), resolve (copy)
					t8.subscriber:unsubscribe(t8.REGISTER_CREDENTIALS_RESPONSE_DESCRIPTOR[s3])
					t8.registerCredentialsRequestInFlight = false

					local json = HttpService:JSONEncode(p4)

					resolve(json)
				end)
			end),
			Promise.delay(n2):andThen(function() -- line: 478
				-- upvalues: t8 (copy), s3 (copy)
				t8.subscriber:unsubscribe(t8.REGISTER_CREDENTIALS_RESPONSE_DESCRIPTOR[s3])
				t8.registerCredentialsRequestInFlight = false
			end)
		})

		t8.registerCredentialsRequestInFlight = true
		MessageBus.publish(t8.REGISTER_CREDENTIALS_REQUEST_DESCRIPTOR[s3], {
			credentialType = s3,
			parameters = HttpService:JSONDecode(s4)
		})

		return v23
	end

	return Promise.reject()
end
function t6.deleteAllCredentialsFromiOSKeychain(t9: {[any]: any}, s5: string, s6: string, n3: number) -- line: 495
	-- upvalues: Promise (copy), HttpService (copy), MessageBus (copy)
	if not t9.deleteIosKeychainCredentialsRequestInFlight then
		local v28 = Promise.race({
			Promise.new(function(resolve, _) -- line: 503
				-- upvalues: t9 (copy), s5 (copy), HttpService (copy)
				t9.subscriber:subscribe(t9.DELETE_IOS_KEYCHAIN_CREDENTIALS_RESPONSE_DESCRIPTOR[s5], function(p6) -- line: 506
					-- upvalues: t9 (copy), s5 (copy), HttpService (copy), resolve (copy)
					t9.subscriber:unsubscribe(t9.DELETE_IOS_KEYCHAIN_CREDENTIALS_RESPONSE_DESCRIPTOR[s5])
					t9.deleteIosKeychainCredentialsRequestInFlight = false

					local json = HttpService:JSONEncode(p6)

					resolve(json)
				end)
			end),
			Promise.delay(n3):andThen(function() -- line: 514
				-- upvalues: t9 (copy), s5 (copy)
				t9.subscriber:unsubscribe(t9.DELETE_IOS_KEYCHAIN_CREDENTIALS_RESPONSE_DESCRIPTOR[s5])
				t9.deleteIosKeychainCredentialsRequestInFlight = false
			end)
		})

		t9.deleteIosKeychainCredentialsRequestInFlight = true
		MessageBus.publish(t9.DELETE_IOS_KEYCHAIN_CREDENTIALS_REQUEST_DESCRIPTOR[s5], {
			credentialType = s5,
			parameters = HttpService:JSONDecode(s6)
		})

		return v28
	end

	return Promise.reject()
end
function t6.deleteAllCredentialsFromKeystore(t10: {[any]: any}, s7: string, s8: string, n4: number) -- line: 533
	-- upvalues: Promise (copy), HttpService (copy), MessageBus (copy)
	if not t10.deleteKeystoreCredentialsRequestInFlight then
		local v33 = Promise.race({
			Promise.new(function(resolve, _) -- line: 541
				-- upvalues: t10 (copy), s7 (copy), HttpService (copy)
				t10.subscriber:subscribe(t10.DELETE_KEYSTORE_CREDENTIALS_RESPONSE_DESCRIPTOR[s7], function(p8) -- line: 544
					-- upvalues: t10 (copy), s7 (copy), HttpService (copy), resolve (copy)
					t10.subscriber:unsubscribe(t10.DELETE_KEYSTORE_CREDENTIALS_RESPONSE_DESCRIPTOR[s7])
					t10.deleteKeystoreCredentialsRequestInFlight = false

					local json = HttpService:JSONEncode(p8)

					resolve(json)
				end)
			end),
			Promise.delay(n4):andThen(function() -- line: 552
				-- upvalues: t10 (copy), s7 (copy)
				t10.subscriber:unsubscribe(t10.DELETE_KEYSTORE_CREDENTIALS_RESPONSE_DESCRIPTOR[s7])
				t10.deleteKeystoreCredentialsRequestInFlight = false
			end)
		})

		t10.deleteKeystoreCredentialsRequestInFlight = true
		MessageBus.publish(t10.DELETE_KEYSTORE_CREDENTIALS_REQUEST_DESCRIPTOR[s7], {
			credentialType = s7,
			parameters = HttpService:JSONDecode(s8)
		})

		return v33
	end

	return Promise.reject()
end
function t6.isAvailable(t11: {[any]: any}, s9: string, n5: number) -- line: 573
	-- upvalues: Promise (copy), MessageBus (copy)
	local v37 = Promise.race({
		Promise.new(function(resolve, _) -- line: 578
			-- upvalues: t11 (copy)
			t11.subscriber:subscribe(t11.IS_AVAILABLE_RESPONSE_DESCRIPTOR, function(p10) -- line: 579
				-- upvalues: t11 (copy), resolve (copy)
				t11.subscriber:unsubscribe(t11.IS_AVAILABLE_RESPONSE_DESCRIPTOR)
				resolve(p10)
			end)
		end),
		Promise.delay(n5):andThen(function() -- line: 584
			-- upvalues: t11 (copy), Promise (copy)
			t11.subscriber:unsubscribe(t11.IS_AVAILABLE_RESPONSE_DESCRIPTOR)

			return Promise.resolve({
				isAvailable = nil,
				supportsDeviceBoundOnly = nil
			})
		end)
	})

	MessageBus.publish(t11.IS_AVAILABLE_REQUEST_DESCRIPTOR, {
		credentialType = s9
	})

	return v37
end

t6.default = t6.new()

return t6
