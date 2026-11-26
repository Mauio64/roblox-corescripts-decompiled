local CorePackages = game:GetService("CorePackages")

local t = require(CorePackages.Packages.t)
local module = require("@luauforge/bundled/egs")
local module2 = require("@luauforge/bundled/gyV")
local module3 = require("@luauforge/bundled/gsu")
local module4 = require("@luauforge/bundled/egt")
local module5 = require("@luauforge/bundled/gyW")

local interface = t.interface({
	birthday = t.string,
	displayName = t.string,
	gender = t.number,
	voucher = t.string,
	channelId = t.number,
	agreementIds = t.table
})

return function(p2, p3, p4, p5, p6)
	return function(object)
		assert(interface(p6))
		return module2(p2, p5, p6):andThen(function(p7)
			p3.Diag:reportCounter(module5.Success, 1)
			object:dispatch(module3(p2, p3, p4))
			return module.resolve()
		end, function(p7)
			p3.Diag:reportCounter(module5.Failure, 1)
			object:dispatch(module4({ HttpError = Enum.HttpError.OK }))
			return module.reject()
		end)
	end
end
