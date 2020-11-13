<html>
<head>
<title>Hello Team!</title>
</head>
<body>
	<h1>Hello Team!</h1>
	<p>
		It is now
		<%= new java.util.Date() %></p>
	<p>
		You are coming from 
		<%= request.getRemoteAddr()  %></p>
</body>
