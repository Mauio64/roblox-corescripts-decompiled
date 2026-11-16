local module = require("@luauforge/bundled/hBw")
local module2 = require("@luauforge/bundled/hBx")
local module3 = require("@luauforge/bundled/hBy")
require("@luauforge/bundled/hBz")

local fFlagEnableMultipageSignupNonInteractiveUserAgreementsPage = require("@luauforge/bundled/hBO").FFlagEnableMultipageSignupNonInteractiveUserAgreementsPage

function LUAUFORGE_MODULE_GLOBALS_hBX_containsValue(items, p2): boolean
	for k, item in pairs(items) do
		if item == p2 then
			return true
		end
	end

	return false
end

local function UpdateActivationWorkflow(p2, p3, p4, p5, list, p6)
	if p5 == module2.Close then
		return nil
	end

	local v5

	if fFlagEnableMultipageSignupNonInteractiveUserAgreementsPage then
		v5 = {}
		v5[module.EnterBirthday] = module.NonInteractiveStoreUserAgreements
		v5[module.NonInteractiveStoreUserAgreements] = module.EnterUserIdentifier
	else
		v5 = {}
		v5[module.EnterBirthday] = module.EnterUserIdentifier
	end

	v5[module.EnterUserIdentifier] = module.AddAuthMethod
	v5[module.AddAuthMethod] = module.SelectGender
	v5[module.SelectGender] = module.Complete
	v5[module.Complete] = module.Complete

	v5[module.TestingPageA] = module.TestingPageB
	v5[module.TestingPageB] = module.TestingPageC

	local v6 = {
		[module.EnterBirthday] = { module2.Next, module2.Close },
		[module.EnterUserIdentifier] = { module2.Next, module2.Back },
		[module.NonInteractiveStoreUserAgreements] = { module2.Next, module2.Back },
		[module.AddAuthMethod] = { module2.Next, module2.Back },
		[module.SelectGender] = { module2.Next, module2.Back },
		[module.Complete] = {},
		[module.TestingPageA] = { module2.Next },
		[module.TestingPageB] = { module2.Next, module2.Back },
		[module.TestingPageC] = {}
	}

	local v7 = table.clone(list)

	if p5 == module2.Next or p5 == module2.Skip then
		if
			p3 == module.EnterUserIdentifier
			and p6
			and p6[module3.SignupPasskeyResult]
			and #p6[module3.SignupPasskeyResult] > 0
		then
			p3 = module.SelectGender
		else
			p3 = v5[p3]

			if p3 == nil then
				return nil
			end
		end

		table.insert(v7, p3)
	elseif p5 == module2.Back then
		if not LUAUFORGE_MODULE_GLOBALS_hBX_containsValue(v6[p3], module2.Back) then
			return nil
		end

		table.remove(v7)

		if #v7 == 0 then
			return nil
		end

		p3 = v7[#v7]
	elseif p5 == module2.Reset then
		p3 = list[1]

		if #list > 0 then
			v7 = { p3 }
		else
			v7 = {}
		end
	end

	local v8 = v6[p3] or {}

	v8 = p3 == module.SelectGender
		and p6
		and p6[module3.SignupPasskeyResult]
		and #p6[module3.SignupPasskeyResult] > 0
		and { module2.Next }
		or v8

	return {
		namespace = p2,
		state = p3,
		availableActions = v8,
		payload = p4,
		history = v7
	}
end

return UpdateActivationWorkflow
