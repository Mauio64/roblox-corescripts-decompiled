local LocalizationService = game:GetService("LocalizationService")
local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dww")
local module2 = require("@luauforge/bundled/ecR")
local Cryo = require(CorePackages.Packages.Cryo)
local module3 = require("@luauforge/bundled/edm")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local tutils = require(CorePackages.Packages.tutils)

local roactServicesContext = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServicesContext

local fFlagMigrateRoactUtilsToReactUtils = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagMigrateRoactUtilsToReactUtils()

local service = roactServices.createService("RoactLocalization")

function service.connect(list)
	local set = {}

	for i, item in ipairs(list) do
		set[item] = true
	end

	return function(value)
		assert(value ~= nil, "Expected component to be passed to connection, got nil.")

		local formatted = ("Localize(%s)"):format((tostring(value)))
		local extended = module2.Component:extend(formatted)

		function extended:init()
			local v5 = service.get(self.props.services)

			assert(
				v5 ~= nil,
				table.concat(
					{
						"Cannot initialize RoactLocalization component without being a descendent of ServiceProvider!",
						("Tried to wrap component %q"):format((tostring(value))),
						"Make sure there is a ServiceProvider above this component in the tree."
					},
					"\n"
				)
			)

			self.state = { locale = LocalizationService.RobloxLocaleId }

			self.localization = v5

			function self.updateLocalization(p2)
				self:setState({ locale = p2 })
			end
		end

		function extended.render(p2)
			local v5 = service.get(p2.props.services)

			local v6 = {}

			for k in pairs(set) do
				local innerProp = p2.props.innerProps[k]
				assert(innerProp ~= nil, ("No localization string or table found for \"%s\""):format(k))
				assert(
					type(innerProp) == "table" or type(innerProp) == "string",
					("Localized field \"%s\" is not a string or table."):format(k)
				)

				if type(innerProp) == "table" then
					assert(
						type(innerProp[1]) == "string",
						("Localization table \"%s\" requires a key of type string, got %s"):format(
							k,
							(type(innerProp[1]))
						)
					)

					v6[k] = v5:Format(innerProp[1], innerProp)
				else
					v6[k] = v5:Format(innerProp)
				end
			end

			local joinDictionaries = module.JoinDictionaries(p2.props.innerProps, v6)

			if type(value) == "string" then
				joinDictionaries.locale = nil
			end

			if fFlagMigrateRoactUtilsToReactUtils then
				return module2.createFragment({
					RobloxLocaleIdChangedConnection = module2.createElement(module3, {
						event = LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"),
						callback = p2.updateLocalization
					}),
					Component = module2.createElement(value, joinDictionaries)
				})
			end

			return module2.createElement(
				module3,
				{
					event = LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"),
					callback = p2.updateLocalization
				},
				{
					Component = module2.createElement(value, joinDictionaries)
				}
			)
		end

		function extended.shouldUpdate(p2, p3, p4): boolean
			if p4 ~= p2.state then
				return true
			end

			for k in pairs(set) do
				local innerProp = p3.innerProps[k]
				local innerProp2 = p2.props.innerProps[k]

				if innerProp == nil or innerProp2 == nil then
					if innerProp ~= nil or innerProp2 ~= nil then
						return true
					end
				elseif type(innerProp) == "table" and type(innerProp2) == "table" then
					if not tutils.shallowEqual(innerProp, innerProp2) then
						return true
					end
				elseif innerProp ~= innerProp2 then
					return true
				end
			end

			return not tutils.shallowEqual(p3, p2.props.innerProps, set)
		end

		local extended2 = module2.PureComponent:extend("ConnectionWrapper")

		function extended2.render(p2)
			return module2.createElement(roactServicesContext.Consumer, {
				render = function(p3)
					local v5 = Cryo.Dictionary.join(p2.props, {
						forwardRef = Cryo.None,
						[module2.Ref] = p2.props.forwardRef
					})

					return module2.createElement(extended, {
						services = p3,
						innerProps = v5
					})
				end
			})
		end

		return module2.forwardRef(function(p2, p3)
			return module2.createElement(extended2, Cryo.Dictionary.join(p2, {
				forwardRef = p3
			}))
		end)
	end
end

return service
