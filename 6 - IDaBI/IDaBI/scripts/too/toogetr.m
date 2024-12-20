 function Dat = toogetr(too, Col, Key, bCnvNum);
%
% function Dat = toogetr(too, Col, Key, bCnvNum);
%
% Returns data in columns 'Col' and in there the rows
% are selected, where the columns 'Col' match the 
% corresponding key in 'Key'.
% too:     see function toogetri
% Col:     see function toogetri
% Key:     see function toogetri
% bCnvNum: boolean flag, if set, the resulting 
%          data matrix is converted into numbers.
%          (default 0)
% Dat:     Data matrix of cell strings if bCnvNum==0, 
%          matrix of numbers if bCnvNum==1.
% 
% see also: too* functions
% creation: ja/99-10-20
% changes:  none
%

Dat	= too.msDat( toogetri(too,Col,Key) , toogetci(too,Col) );
if nargin > 3,	
	if bCnvNum,
		Dat = cnvx2n(Dat);
	end;
end;

return;
%%-------------------------------------------------------------------------
%%
%%	Copyright (C) 1999   	Jens-E. Appell, Carl-von-Ossietzky-Universitat
%%	
%%	Permission to use, copy, and distribute this software/file and its
%%	documentation for any purpose without permission by the author
%%	is strictly forbidden.
%%
%%	Permission to modify the software is granted, but not the right to
%%	distribute the modified code.
%%
%%	This software is provided "as is" without expressed or implied warranty.
%%
%%
%%	AUTHOR
%%
%%		Jens-E. Appell
%%		Carl-von-Ossietzky-Universitat
%%		Fachbereich 8, AG Medizinische Physik
%%		26111 Oldenburg
%%		Germany
%%
%%		e-mail:		jens@medi.physik.uni-oldenburg.de
%%
%%-------------------------------------------------------------------------
