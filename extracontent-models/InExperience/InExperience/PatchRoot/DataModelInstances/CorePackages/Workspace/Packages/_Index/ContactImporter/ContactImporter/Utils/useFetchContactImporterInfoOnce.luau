local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local AppStorageService = dependencies.AppStorageService
local useDispatch = dependencies.useDispatch
local useSelector = dependencies.useSelector
local useEffectOnce = dependencies.useEffectOnce
local FetchContactImporterParams = require(ParentParent.Networking.FetchContactImporterParams)
local PermissionsProtocol = dependencies.PermissionsProtocol
local useContactImporterConfiguration = require(script.Parent.useContactImporterConfiguration)

return function(t1: {[any]: any}) -- line: 12
	-- upvalues: useSelector (copy), useDispatch (copy), FetchContactImporterParams (copy), PermissionsProtocol (copy), AppStorageService (copy), useContactImporterConfiguration (copy), useEffectOnce (copy)
	local v11 = useSelector(function(p1) -- line: 13
		return p1.LocalUserId
	end)
	local v12 = useDispatch()
	local v13 = useContactImporterConfiguration(t1).shouldFetchContactImporterData and (v11 and (v11 ~= "" and v11 ~= "0"))

	useEffectOnce(function() -- line: 19
		-- upvalues: v12 (copy), FetchContactImporterParams (copy), v11 (copy), PermissionsProtocol (copy), AppStorageService (copy)
		v12(FetchContactImporterParams(v11, PermissionsProtocol.default, AppStorageService))
	end, v13)
end
