local bit=require"bit" local bor=bit.bor local bxor=bit.bxor local band=bit.band local rshift=bit.rshift local arshift=bit.arshift local lshift=bit.lshift local p=require"md5p2" local binl=p.binl
local function binl2rstr(input) local i local output={} local length32=#input*32 for i=0,length32-1,8 do table.insert(output,string.char(band(rshift(input[1+arshift(i,5)],i%32),0xff))) end return table.concat(output,'') end
local function rstr2binl(input) local output={} for i=1,arshift( string.len(input),2) do output[i]=0 end local length8=string.len(input) * 8 for i=0,length8-1,8 do local p=1+arshift(i,5) if output[p]==nil then output[p]=0 end
output[p]=bor(output[p],lshift(band(input:byte((i/8)+1),0xff),(i%32))) end return output end local function rstrMD5 (s) return binl2rstr(binl(rstr2binl(s),string.len(s) * 8)) end
local function concatArray(a,b) local c={} for _,v in ipairs(a) do table.insert(c,v) end for _,v in ipairs(b) do table.insert(c,v) end end local function charAt(str,n) return string.sub(str,n,n) end
local function rstrHMACMD5 (key,data) local i local bkey=rstr2binl(key) local ipad={} local opad={} local hash ipad[15]=nil opad[15]=nil if string.len(bkey) > 16 then bkey=binl(bkey,string.len(key) * 8) end
for i=1,16 do ipad[i]=bxor(bkey[i],0x36363636) opad[i]=bxor(bkey[i],0x5c5c5c5c) end hash=binl(concatArray(ipad,rstr2binl(data)),512+string.len(data) * 8) return binl2rstr(binl(concatArray(opad,hash),512+128)) end
local function rstr2hex (input) local hexTab='0123456789abcdef' local output={} for i=1,string.len(input) do local x=input:byte(i) table.insert(output,charAt(hexTab,1+band( rshift(x,4),0x0f)))
table.insert(output,charAt(hexTab,1+band(x,0x0f)) ) end return table.concat(output,'') end local function rawMD5 (s) return rstrMD5(s) end
local function hexMD5 (s) return rstr2hex(rawMD5(s)) end local function rawHMACMD5 (k,d) return rstrHMACMD5(k,d) end local function hexHMACMD5 (k,d) return rstr2hex(rawHMACMD5(k,d)) end
local function md5 (str,key,raw) if not key then if not raw then return hexMD5(str) end return rawMD5(str) end if not raw then return hexHMACMD5(key,str) end return rawHMACMD5(key,str) end
return { md5=md5,hexMD5=hexMD5,rawMD5=rawMD5,hexHMACMD5=hexHMACMD5,rawHMACMD5=rawHMACMD5 }
