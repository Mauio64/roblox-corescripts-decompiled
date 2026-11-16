local module = require("@luauforge/bundled/fJc")
local memoize = require("@luauforge/bundled/fJg").memoize

require("@luauforge/bundled/fJp")
local module2 = require("@luauforge/bundled/fJD")
local module3 = require("@luauforge/bundled/fKw")
local module4 = require("@luauforge/bundled/fKz")
local module5 = require("@luauforge/bundled/fKH")
local module6 = require("@luauforge/bundled/fKJ")
local module7 = require("@luauforge/bundled/fKO")
local module8 = require("@luauforge/bundled/fKP")

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
