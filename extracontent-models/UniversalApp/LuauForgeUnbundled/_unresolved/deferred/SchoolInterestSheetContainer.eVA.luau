local module = require("@luauforge/deferred/egU")

local module2 = require("@luauforge/deferred/eVB")
local module3 = require("@luauforge/deferred/eVD")
local module4 = require("@luauforge/deferred/eUF")
local module5 = require("@luauforge/deferred/eVz")

local v5 = if module5 then require("@luauforge/deferred/eUy") else nil

local function SchoolInterestSheetContainer(props)
	local v6 = if module5 then v5.useSchoolsAnalytics() else nil

	module.useEffect(function()
		if module5 and module4 and props.isOpen and props.entryPoint then
			v6(v5.EventNames.SchoolInterestSheetImpression, {
				entryPoint = props.entryPoint
			})
		end
	end, { props.isOpen, props.entryPoint, v6 })

	local v7 = module3(props.isOpen, props.onClose)
	return module.createElement(module2, v7)
end

return SchoolInterestSheetContainer
