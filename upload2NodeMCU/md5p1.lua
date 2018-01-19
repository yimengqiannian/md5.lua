local bit=require"bit" local bnot=bit.bnot local bor=bit.bor local bxor=bit.bxor local band=bit.band local rshift=bit.rshift local arshift=bit.arshift local lshift=bit.lshift
local function safeAdd (x,y) if x==nil then x=0 end if y==nil then y=0 end local lsw=band(x,0xffff)+band(y,0xffff) local msw=arshift(x,16)+arshift(y,16)+arshift(lsw,16) return bor(lshift(msw,16),band(lsw,0xffff)) end
local function bitRotateLeft (num,cnt) return bor( lshift(num,cnt),rshift(num,(32-cnt)) ) end local function cnm (q,a,b,x,s,t) return safeAdd(bitRotateLeft(safeAdd(safeAdd(a,q),safeAdd(x,t)),s),b) end
local function ff (a,b,c,d,x,s,t) return cnm( bor(band(b,c),band(bnot(b),d) ),a,b,x,s,t) end local function gg (a,b,c,d,x,s,t) return cnm( bor(band(b,d),band(c,bnot(d)) ),a,b,x,s,t) end
local function hh (a,b,c,d,x,s,t) return cnm( bxor(b,c,d),a,b,x,s,t) end local function ii (a,b,c,d,x,s,t) return cnm( bxor(c,bor( b,bnot(d) ) ),a,b,x,s,t) end
return {safeAdd=safeAdd,bitRotateLeft=bitRotateLeft,cmn=cmn,ff=ff,gg=gg,hh=hh,ii=ii}
