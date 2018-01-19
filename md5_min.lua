local bit=require"bit" local bnot=bit.bnot local bor=bit.bor local bxor=bit.bxor local band=bit.band local rshift=bit.rshift local arshift=bit.arshift local lshift=bit.lshift
local function safeAdd (x,y) if x==nil then x=0 end if y==nil then y=0 end local lsw=band(x,0xffff)+band(y,0xffff) local msw=arshift(x,16)+arshift(y,16)+arshift(lsw,16) return bor(lshift(msw,16),band(lsw,0xffff)) end
local function bitRotateLeft (num,cnt) return bor( lshift(num,cnt),rshift(num,(32-cnt)) ) end local function cnm (q,a,b,x,s,t) return safeAdd(bitRotateLeft(safeAdd(safeAdd(a,q),safeAdd(x,t)),s),b) end
local function ff (a,b,c,d,x,s,t) return cnm( bor(band(b,c),band(bnot(b),d) ),a,b,x,s,t) end local function gg (a,b,c,d,x,s,t) return cnm( bor(band(b,d),band(c,bnot(d)) ),a,b,x,s,t) end
local function hh (a,b,c,d,x,s,t) return cnm( bxor(b,c,d),a,b,x,s,t) end local function ii (a,b,c,d,x,s,t) return cnm( bxor(c,bor( b,bnot(d) ) ),a,b,x,s,t) end
local function binl (x,len) x[1+arshift(len,5)]=bor( x[1+arshift(len,5)],lshift(0x80,(len % 32)) ) x[1+lshift(rshift( len+64,9 ),4)+14]=len local i local olda local oldb local oldc local oldd local a=1732584193 local b=-271733879
local c=-1732584194 local d=271733878 for i=1,#x,16 do olda=a oldb=b oldc=c oldd=d a=ff(a,b,c,d,x[i],7,-680876936) d=ff(d,a,b,c,x[i+1],12,-389564586) c=ff(c,d,a,b,x[i+2],17,606105819) b=ff(b,c,d,a,x[i+3],22,-1044525330)
a=ff(a,b,c,d,x[i+4],7,-176418897) d=ff(d,a,b,c,x[i+5],12,1200080426) c=ff(c,d,a,b,x[i+6],17,-1473231341) b=ff(b,c,d,a,x[i+7],22,-45705983) a=ff(a,b,c,d,x[i+8],7,1770035416) d=ff(d,a,b,c,x[i+9],12,-1958414417)
c=ff(c,d,a,b,x[i+10],17,-42063) b=ff(b,c,d,a,x[i+11],22,-1990404162) a=ff(a,b,c,d,x[i+12],7,1804603682) d=ff(d,a,b,c,x[i+13],12,-40341101) c=ff(c,d,a,b,x[i+14],17,-1502002290) b=ff(b,c,d,a,x[i+15],22,1236535329)
a=gg(a,b,c,d,x[i+1],5,-165796510) d=gg(d,a,b,c,x[i+6],9,-1069501632) c=gg(c,d,a,b,x[i+11],14,643717713) b=gg(b,c,d,a,x[i],20,-373897302) a=gg(a,b,c,d,x[i+5],5,-701558691) d=gg(d,a,b,c,x[i+10],9,38016083)
c=gg(c,d,a,b,x[i+15],14,-660478335) b=gg(b,c,d,a,x[i+4],20,-405537848) a=gg(a,b,c,d,x[i+9],5,568446438) d=gg(d,a,b,c,x[i+14],9,-1019803690) c=gg(c,d,a,b,x[i+3],14,-187363961) b=gg(b,c,d,a,x[i+8],20,1163531501)
a=gg(a,b,c,d,x[i+13],5,-1444681467) d=gg(d,a,b,c,x[i+2],9,-51403784) c=gg(c,d,a,b,x[i+7],14,1735328473) b=gg(b,c,d,a,x[i+12],20,-1926607734) a=hh(a,b,c,d,x[i+5],4,-378558) d=hh(d,a,b,c,x[i+8],11,-2022574463)
c=hh(c,d,a,b,x[i+11],16,1839030562) b=hh(b,c,d,a,x[i+14],23,-35309556) a=hh(a,b,c,d,x[i+1],4,-1530992060) d=hh(d,a,b,c,x[i+4],11,1272893353) c=hh(c,d,a,b,x[i+7],16,-155497632) b=hh(b,c,d,a,x[i+10],23,-1094730640)
a=hh(a,b,c,d,x[i+13],4,681279174) d=hh(d,a,b,c,x[i],11,-358537222) c=hh(c,d,a,b,x[i+3],16,-722521979) b=hh(b,c,d,a,x[i+6],23,76029189) a=hh(a,b,c,d,x[i+9],4,-640364487) d=hh(d,a,b,c,x[i+12],11,-421815835)
c=hh(c,d,a,b,x[i+15],16,530742520) b=hh(b,c,d,a,x[i+2],23,-995338651) a=ii(a,b,c,d,x[i],6,-198630844) d=ii(d,a,b,c,x[i+7],10,1126891415) c=ii(c,d,a,b,x[i+14],15,-1416354905) b=ii(b,c,d,a,x[i+5],21,-57434055)
a=ii(a,b,c,d,x[i+12],6,1700485571) d=ii(d,a,b,c,x[i+3],10,-1894986606) c=ii(c,d,a,b,x[i+10],15,-1051523) b=ii(b,c,d,a,x[i+1],21,-2054922799) a=ii(a,b,c,d,x[i+8],6,1873313359) d=ii(d,a,b,c,x[i+15],10,-30611744)
c=ii(c,d,a,b,x[i+6],15,-1560198380) b=ii(b,c,d,a,x[i+13],21,1309151649) a=ii(a,b,c,d,x[i+4],6,-145523070) d=ii(d,a,b,c,x[i+11],10,-1120210379) c=ii(c,d,a,b,x[i+2],15,718787259) b=ii(b,c,d,a,x[i+9],21,-343485551)
a=safeAdd(a,olda) b=safeAdd(b,oldb) c=safeAdd(c,oldc) d=safeAdd(d,oldd) end return {a,b,c,d} end local function binl2rstr (input) local i local output={} local length32=#input * 32
for i=0,length32-1,8 do table.insert(output,string.char( band(rshift( input[1+arshift(i,5)],i % 32 ),0xff ) ) ) end return table.concat(output,'') end local function rstr2binl (input) local output={}
for i=1,arshift( string.len(input),2) do output[i]=0 end local length8=string.len(input) * 8 for i=0,length8-1,8 do local p=1+arshift(i,5) if output[p]==nil then output[p]=0 end
output[p]=bor( output[p],lshift( band(input:byte((i / 8)+1),0xff),(i % 32) ) ) end return output end local function rstrMD5 (s) return binl2rstr(binl(rstr2binl(s),string.len(s) * 8)) end
local function concatArray(a,b) local c={} for _,v in ipairs(a) do table.insert(c,v) end for _,v in ipairs(b) do table.insert(c,v) end end local function charAt(str,n) return string.sub(str,n,n) end
local function rstrHMACMD5 (key,data) local i local bkey=rstr2binl(key) local ipad={} local opad={} local hash ipad[15]=nil opad[15]=nil if string.len(bkey) > 16 then bkey=binl(bkey,string.len(key) * 8) end
for i=1,16 do ipad[i]=bxor(bkey[i],0x36363636) opad[i]=bxor(bkey[i],0x5c5c5c5c) end hash=binl(concatArray(ipad,rstr2binl(data)),512+string.len(data) * 8) return binl2rstr(binl(concatArray(opad,hash),512+128)) end
local function rstr2hex (input) local hexTab='0123456789abcdef' local output={} for i=1,string.len(input) do local x=input:byte(i) table.insert(output,charAt(hexTab,1+band( rshift(x,4),0x0f)) )
table.insert(output,charAt(hexTab,1+band(x,0x0f)) ) end return table.concat(output,'') end local function str2rstrUTF8 (input) return input end local function rawMD5 (s) return rstrMD5(str2rstrUTF8(s)) end
local function hexMD5 (s) return rstr2hex(rawMD5(s)) end local function rawHMACMD5 (k,d) return rstrHMACMD5(str2rstrUTF8(k),str2rstrUTF8(d)) end local function hexHMACMD5 (k,d) return rstr2hex(rawHMACMD5(k,d)) end
local function md5 (str,key,raw) if not key then if not raw then return hexMD5(str) end return rawMD5(str) end if not raw then return hexHMACMD5(key,str) end return rawHMACMD5(key,str) end
return { md5=md5,hexMD5=hexMD5,rawMD5=rawMD5,hexHMACMD5=hexHMACMD5,rawHMACMD5=rawHMACMD5 }
