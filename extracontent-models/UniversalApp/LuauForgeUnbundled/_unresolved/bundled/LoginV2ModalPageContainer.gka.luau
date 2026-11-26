local module = require("@luauforge/bundled/ggX")
local module2 = require("@luauforge/bundled/gjT")
local module3 = require("@luauforge/bundled/gjG")

local module4 = require("@luauforge/bundled/gkb")
local module5 = require("@luauforge/bundled/gkc")
local module6 = require("@luauforge/bundled/gke")
local module7 = require("@luauforge/bundled/gjP")

local authModalShown = module3.Events.authModalShown
local eventStreamConstants = module3.EventStreamConstants

local function LoginV2ModalPageContainer(props)
	local v5 = module4()

	module.useEffect(function()
		if module6() and v5.useModalLayout and props.eventContext ~= nil then
			local eventContext = props.eventContext
			local v7 = if module7 then eventStreamConstants.ActionType.Shown else nil
			authModalShown(
				eventContext,
				v7,
				eventStreamConstants.Field.LoginV2Modal,
				eventStreamConstants.Origin.LoginV2Modalized
			)
		end
	end, { props.eventContext, v5.useModalLayout })

	return module.createElement(
		module5,
		module2.Dictionary.join(v5, {
			header = props.header,
			onClose = props.onClose,
			isCoveredByDialog = props.isCoveredByDialog,
			children = props.children
		})
	)
end

return LoginV2ModalPageContainer
