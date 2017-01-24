
package com.example;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.loadbalancer.LoadBalanced;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;
import org.springframework.context.annotation.Bean;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@SpringBootApplication
@EnableEurekaClient
@RestController
public class EurekaBrixtonClientTesterApplication {

	@Autowired @LoadBalanced
	RestTemplate restTemplate;

	@Bean @LoadBalanced
	RestTemplate restTemplate() {
		return new RestTemplate();
	}

	@RequestMapping("/check")
	public String getHealthOfClient() {
		return restTemplate.getForObject("http://client/health", String.class);
	}

	public static void main(String[] args) {
		SpringApplication.run(EurekaBrixtonClientTesterApplication.class, args);
	}
}
