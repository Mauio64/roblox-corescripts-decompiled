local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/fJc")
local url = require("@luauforge/bundled/fJa").Url
require("@luauforge/bundled/fJa")
local default = require("@luauforge/bundled/fJd").default

local module2 = require("@luauforge/bundled/fIZ")

local module3 = require("@luauforge/bundled/fJe")

local v5 = {}

function v5.attribute(callback, p2, p3, p4, p5)
	return module.new(function(callback2)
		local jsonEncode = HttpService:JSONEncode({
			linkId = p2,
			referralUrl = p3,
			linkType = p4,
			userDidLogIn = p5
		})

		callback(string.format("%saffiliate-links/v1/events/authenticated-visit", url.APIS_URL), "POST", {
			postBody = jsonEncode
		}):await()
		callback2()
	end)
end

function v5.attributeJoinLink(p2, p3, p4, p5)
	return module.new(function(callback)
		local v6, v7 = module2.resolveReferralCode(p2, p4):await()

		if v6 then
			v5.attribute(p2, v7.responseBody.linkId, p3, v7.responseBody.linkType, p5):await()
		else
			default:logRobloxTelemetryCounter(module3.AttributeJoinLinkFailureCounter)
		end

		callback()
	end)
end

return v5
