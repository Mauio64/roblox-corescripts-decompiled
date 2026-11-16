local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)

local appStorageService = dependencies.AppStorageService
local useDispatch = dependencies.useDispatch
local useSelector = dependencies.useSelector
local useEffectOnce = dependencies.useEffectOnce
local FetchContactImporterParams = require(parent.Networking.FetchContactImporterParams)
local permissionsProtocol = dependencies.PermissionsProtocol
local useContactImporterConfiguration = require(script.Parent.useContactImporterConfiguration)

return function(p)
	local v = useSelector(function(p2)
		return p2.LocalUserId
	end)

	local v2 = useDispatch()

	local function fn()
		v2(FetchContactImporterParams(v, permissionsProtocol.default, appStorageService))
	end

	local v3 = useContactImporterConfiguration(p).shouldFetchContactImporterData

	if v3 then
		if v then
			if v == "" then
				v3 = false
			else
				v3 = v ~= "0"
			end
		else
			v3 = v
		end
	end

	useEffectOnce(fn, v3)
end
