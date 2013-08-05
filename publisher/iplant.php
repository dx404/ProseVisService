<?php 
function authenticated_post($url, $uname, $pass, $form_vars=array()){
	$post_data = $form_vars;
	var_dump($post_data);
	error_log("invoking post on $url with $post_data");
	echo "here end.";

	$curl = curl_init();
	curl_setopt($curl, CURLOPT_HTTPAUTH, CURLAUTH_ANY ) ;
	curl_setopt($curl, CURLOPT_USERPWD, "$uname:$pass");
	curl_setopt($curl, CURLOPT_SSLVERSION,3);
	curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, FALSE);
	curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, 1);
	curl_setopt($curl, CURLOPT_HEADER, false);
	curl_setopt($curl, CURLOPT_POST, true);
	curl_setopt($curl, CURLOPT_POSTFIELDS, $post_data );
	curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($curl, CURLOPT_URL, $url);

	$response = curl_exec($curl);
	error_log($response);
	curl_close($curl);

	return json_decode($response, false);
}

$info  = authenticated_post(
		//'https://iplant-dev.tacc.utexas.edu/v2/files/postits/', 
		'https://iplant-dev.tacc.utexas.edu/v2/postits/', 
		'duotacc', '48bd617dbbc4237e312c4027c82de953', 
		array('username' => 'duotacc',
				//'url'=>'https://iplant-dev.tacc.utexas.edu/v2/files/listings/system/ischool.stampede/avary.xml', 
				'url'=>'https://iplant-dev.tacc.utexas.edu/v2/files/system/ischool.stampede/avary.xml', 
				'method'=>'GET'));
var_dump($info);

?>