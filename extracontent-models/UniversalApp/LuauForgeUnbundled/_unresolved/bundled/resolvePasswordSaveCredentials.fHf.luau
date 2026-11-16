local function resolvePasswordSaveCredentials(data)
	if data == nil then
		return nil
	end

	local v5 = data.canonicalUsername

	if v5 == nil or v5 == "" then
		v5 = data.cvalue
	end

	local password = data.password

	if v5 == nil or v5 == "" or password == nil or password == "" then
		return nil
	end

	return { username = v5, password = password }
end

return resolvePasswordSaveCredentials
