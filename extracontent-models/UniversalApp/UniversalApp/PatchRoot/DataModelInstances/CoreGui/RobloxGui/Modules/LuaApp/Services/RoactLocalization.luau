local Modules = game:GetService("CoreGui").RobloxGui.Modules
local LocalizationService = game:GetService("LocalizationService")
local CorePackages = game:GetService("CorePackages")
local Immutable = require(Modules.Common.Immutable)
local Roact = require(Modules.Common.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local ExternalEventConnection = require(Modules.Common.RoactUtilities.ExternalEventConnection)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local tutils = require(CorePackages.Packages.tutils)
local RoactServicesContext = require(CorePackages.Workspace.Packages.RoactServices).RoactServicesContext
local v11 = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagMigrateRoactUtilsToReactUtils()
local v12 = RoactServices.createService(script.Name)

function v12.connect(p1) -- line: 23
	-- upvalues: Roact (copy), v12 (copy), LocalizationService (copy), Immutable (copy), v11 (copy), ExternalEventConnection (copy), tutils (copy), RoactServicesContext (copy), Cryo (copy)
	local t1 = {}

	for _, v in ipairs(p1) do
		t1[v] = true
	end

	return function(p2) -- line: 29
		-- upvalues: Roact (copy), v12 (copy), LocalizationService (copy), t1 (copy), Immutable (copy), v11 (copy), ExternalEventConnection (copy), tutils (copy), RoactServicesContext (copy), Cryo (copy)
		assert(p2 ~= nil, "Expected component to be passed to connection, got nil.")

		local v18 = ("Localize(%s)"):format((tostring(p2)))
		local v19 = Roact.Component:extend(v18)

		function v19.init(p3) -- line: 35
			-- upvalues: v12 (copy), p2 (copy), LocalizationService (copy)
			local v22 = v12.get(p3.props.services)

			assert(v22 ~= nil, table.concat({
				"Cannot initialize RoactLocalization component without being a descendent of ServiceProvider!",
				("Tried to wrap component %q"):format((tostring(p2))),
				"Make sure there is a ServiceProvider above this component in the tree."
			}, "\n"))
			p3.state = {
				locale = LocalizationService.RobloxLocaleId
			}
			p3.localization = v22

			function p3.updateLocalization(p4) -- line: 52
				-- upvalues: p3 (copy)
				p3:setState({
					locale = p4
				})
			end
		end
		function v19.render(p5) -- line: 59
			-- upvalues: v12 (copy), t1 (copy), Immutable (copy), p2 (copy), v11 (copy), Roact (copy), ExternalEventConnection (copy), LocalizationService (copy)
			local v24 = v12.get(p5.props.services)
			local t2 = {}

			for k in pairs(t1) do
				local v27 = p5.props.innerProps[k]

				assert(v27 ~= nil, ("No localization string or table found for \"%s\""):format(k))
				assert(type(v27) == "table" or type(v27) == "string", ("Localized field \"%s\" is not a string or table."):format(k))

				if type(v27) == "table" then
					assert(type(v27[1]) == "string", ("Localization table \"%s\" requires a key of type string, got %s"):format(k, (type(v27[1]))))
					t2[k] = v24:Format(v27[1], v27)
				else
					t2[k] = v24:Format(v27)
				end
			end

			local v28 = Immutable.JoinDictionaries(p5.props.innerProps, t2)

			if type(p2) == "string" then
				v28.locale = nil
			end

			if v11 then
				return Roact.createFragment({
					RobloxLocaleIdChangedConnection = Roact.createElement(ExternalEventConnection, {
						event = LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"),
						callback = p5.updateLocalization
					}),
					Component = Roact.createElement(p2, v28)
				})
			end

			return Roact.createElement(ExternalEventConnection, {
				event = LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"),
				callback = p5.updateLocalization
			}, {
				Component = Roact.createElement(p2, v28)
			})
		end
		function v19.shouldUpdate(p6, p7, p8) -- line: 109
			-- upvalues: t1 (copy), tutils (copy)
			if p8 ~= p6.state then
				return true
			end

			for k in pairs(t1) do
				local v33 = p7.innerProps[k]
				local v34 = p6.props.innerProps[k]

				if v33 ~= nil and v34 ~= nil then
					if type(v33) == "table" and type(v34) == "table" then
						if tutils.shallowEqual(v33, v34) then
							continue
						end

						return true
					end

					if v33 == v34 then
						continue
					end

					return true
				end

				if v33 ~= nil or v34 ~= nil then
					return true
				end
			end

			return not tutils.shallowEqual(p7, p6.props.innerProps, t1)
		end

		local v20 = Roact.PureComponent:extend("ConnectionWrapper")

		function v20.render(p9) -- line: 135
			-- upvalues: Roact (copy), RoactServicesContext (copy), Cryo (copy), v19 (copy)
			return Roact.createElement(RoactServicesContext.Consumer, {
				render = function(p10) -- line: 137
					-- upvalues: Cryo (copy), p9 (copy), Roact (copy), v19 (copy)
					local v40 = Cryo.Dictionary.join(p9.props, {
						forwardRef = Cryo.None,
						[Roact.Ref] = p9.props.forwardRef
					})

					return Roact.createElement(v19, {
						services = p10,
						innerProps = v40
					})
				end
			})
		end

		return Roact.forwardRef(function(p11, p12) -- line: 151
			-- upvalues: Roact (copy), v20 (copy), Cryo (copy)
			return Roact.createElement(v20, Cryo.Dictionary.join(p11, {
				forwardRef = p12
			}))
		end)
	end
end

return v12
