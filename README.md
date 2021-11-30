# Code Challenges

## Exercise 1

The below commands to create list of queues and it's dlq's in AWS using terraform CLIs.


terraform init   

terraform plan -var='queue_names=["queue1", "queue2", "queue3"]'

terraform apply -var='queue_names=["queue1", "queue2", "queue3"]'


## Exercise 2

I used the same repo to keep the python script to retrive list of sqs queues and its count. The below command will be help to run the python script to retrive the appropriate results.

python queue_count.py queue1 queue2

