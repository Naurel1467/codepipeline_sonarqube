#!/binh


sonar_host_url="http://13.233.96.111:9000"
sonar_token=ba7078198cedf800060524cb5ff040b92a2e4c73

result=$(mvn clean sonar:sonar -Dsonar.projectKey=PullRequestApproverBlogDemo -Dsonar.host.url=http://13.233.96.111:9000/  -Dsonar.login=$sonar_token)


echo $result

sonar_link=$(echo $result | egrep -o "you can browse http://[^, ]+")
#sonar_task_id=$(echo $result | egrep -o "task\id=[^ ]+" | cut -d'=' -f2)
sonar_task_id=$(echo $result | egrep -o "task\?id=[^ ]+" | cut -d'=' -f2)

echo $sonar_task_id
 


stat="PENDING";
while [ "$stat" != "SUCCESS" ]; do
  if [ $stat = "FAILED" ] || [ $stat = "CANCELLED" ]; then
     echo "SonarQube task $sonar_task_id failed";
     exit 1;
  fi
  stat=$(curl -u "admin:12345678" http://13.233.96.111:9000/api/ce/task\?id=$sonar_task_id | jq -r '.task.status');
  echo "SonarQube analysis status is $stat";
  sleep 5;  
done
