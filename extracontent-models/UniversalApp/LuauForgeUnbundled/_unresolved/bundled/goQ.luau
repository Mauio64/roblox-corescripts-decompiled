local module = require("@luauforge/bundled/gnx")
local memoize = require("@luauforge/bundled/gnB").memoize

require("@luauforge/bundled/gnK")
local module2 = require("@luauforge/bundled/gnY")
local module3 = require("@luauforge/bundled/goR")
local module4 = require("@luauforge/bundled/goU")
local module5 = require("@luauforge/bundled/gpc")
local module6 = require("@luauforge/bundled/gpe")
local module7 = require("@luauforge/bundled/gpj")
local module8 = require("@luauforge/bundled/gpk")

return memoize(function(p2)
	if p2 == nil then
		return nil
	end

	if p2.modalState == module2.UPDATE_EMAIL then
		return module.createElement(module3, p2.props)
	end

	if p2.modalState == module2.SAVE_OR_DELETE_TWO_STEP_METHOD then
		return module.createElement(module4, p2.props)
	end

	if p2.modalState == module2.ADD_NEW_PASSKEY then
		return module.createElement(module5, p2.props)
	end

	if p2.modalState == module2.INVALIDATE_CREDENTIALS then
		return module.createElement(module6, p2.props)
	end

	if p2.modalState == module2.ACCOUNT_SECURED then
		return module.createElement(module7, p2.props)
	end

	if p2.modalState == module2.NO_CHANGES_MADE then
		return module.createElement(module8, p2.props)
	end

	return nil
end)
