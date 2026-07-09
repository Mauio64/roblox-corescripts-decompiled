local HttpService = game:GetService("HttpService")
local SelfieQr = script:FindFirstAncestor("SelfieQr")
local SelfieQrParent = SelfieQr.Parent
local CoreScriptsRootProvider = require(SelfieQrParent.CoreScriptsRoactCommon).CoreScriptsRootProvider
local React = require(SelfieQrParent.React)
local Roact = require(SelfieQrParent.Roact)
local RoactNetworking = require(SelfieQrParent.RoactServiceTags).RoactNetworking
local RoactServices = require(SelfieQrParent.RoactServices).RoactServices
local SelfieQRConnection = require(SelfieQr.SelfieQRConnection)
local requestInternalWrapper = require(SelfieQrParent.Http).NetworkLayers.requestInternalWrapper
local t1 = {}
local u12 = false

local function v13(p1, t2: {[any]: any}) -- line: 18
	-- upvalues: React (copy), CoreScriptsRootProvider (copy), RoactServices (copy), RoactNetworking (copy), requestInternalWrapper (copy), HttpService (copy), Roact (copy)
	local v16 = React.createElement(CoreScriptsRootProvider, {}, {
		RoactServicesProvider = React.createElement(RoactServices.ServiceProvider, {
			services = {
				[RoactNetworking] = requestInternalWrapper(HttpService)
			}
		}, t2)
	})
	local v17 = React.createElement("Folder", nil, v16)

	return Roact.mount(v17, p1, "SelfieQRRoot")
end

function t1.createFactory() -- line: 32
	-- upvalues: u12 (ref), v13 (copy), React (copy), SelfieQRConnection (copy)
	local t3 = {}

	function t3.mountCoreUI(p2) -- line: 34
		-- upvalues: u12 (ref), t3 (copy), v13 (copy), React (copy), SelfieQRConnection (copy)
		if u12 then
			return
		end

		u12 = true
		t3._coreUiHandle = v13(p2, {
			SelfieQR = React.createElement(SelfieQRConnection, {})
		})
	end

	return t3
end

return t1
