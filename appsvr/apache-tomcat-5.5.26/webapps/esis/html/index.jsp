<%--
  -- ESIS
  --
  -- Copyright (c) 2004-2008 Entelience SARL,  Copyright (c) 2008-2009 Equity SA
  -- Copyright (c) 2010 Consulare sàrl
  -- 
  -- This file is part of ESIS.
  --
  -- ESIS is free software: you can redistribute it and/or modify
  -- it under the terms of the GNU General Public License as published by
  -- the Free Software Foundation version 3 of the License.
  --
  -- ESIS is distributed in the hope that it will be useful,
  -- but WITHOUT ANY WARRANTY; without even the implied warranty of
  -- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  -- GNU General Public License for more details.
  --
  -- You should have received a copy of the GNU General Public License
  -- along with ESIS.  If not, see <http://www.gnu.org/licenses/>.
  --
  -- $Id: index.jsp 373 2010-04-09 18:46:30Z pleberre $
  --
  --%>
<%@ page import="com.entelience.util.DateHelper" %>
<%@include file="page_header.inc.jsp"%>
	<h1>ESIS <%= DateHelper.HTMLDateOrNull(DateHelper.now()) %></h1>
<%@include file="page_footer.inc.jsp"%>
