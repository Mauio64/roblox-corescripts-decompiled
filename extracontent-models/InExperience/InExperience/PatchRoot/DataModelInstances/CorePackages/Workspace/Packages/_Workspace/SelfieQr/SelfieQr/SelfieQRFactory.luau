local HttpService = game:GetService("HttpService")

local SelfieQr = script:FindFirstAncestor("SelfieQr")
local parent = SelfieQr.Parent

local CoreScriptsRoactCommon = require(parent.CoreScriptsRoactCommon)
local CoreScriptsRootProvider = CoreScriptsRoactCommon.CoreScriptsRootProvider
local React = require(parent.React)
local Roact = require(parent.Roact)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RoactServices = require(parent.RoactServices)
local roactServices = RoactServices.RoactServices
local SelfieQRConnection = require(SelfieQr.SelfieQRConnection)

local Http = require(parent.Http)
local requestInternalWrapper = Http.NetworkLayers.requestInternalWrapper

local flag = false

local function fn(p, p2)
	local element = React.createElement(CoreScriptsRootProvider, {}, {
		RoactServicesProvider = React.createElement(roactServices.ServiceProvider, {
			services = {
				[RoactNetworking] = requestInternalWrapper(HttpService)
			}
		}, p2)
	})

	local element2 = React.createElement("Folder", nil, element)

	return Roact.mount(element2, p, "SelfieQRRoot")
end

return {
	createFactory = function()
		local factory = {}
		function factory.mountCoreUI(p)
			if flag then
				return
			end

			flag = true

			factory._coreUiHandle = fn(p, {
				SelfieQR = React.createElement(SelfieQRConnection, {})
			})
		end
		return factory
	end
}
