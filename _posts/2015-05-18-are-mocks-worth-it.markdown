---
layout: post
title: Are mocks worth it?
date: '2015-05-18T07:23:00.000-08:00'
author: Hemant Kumar
tags: tdd
categories: kodekitab
comments: true
modified_time: '2015-05-18T07:50:46.244-08:00'
redirect_from: "/kodekitab/2015/05/18/are-mocks-worth-it.html"
---

Mocks are widely used in most development teams I've worked with practicing TDD. According to [Uncle Bob](http://blog.8thlight.com/uncle-bob/2014/05/10/WhenToMock.html) *A mock object is a very powerful tool, providing two major benefits: isolation and introspection. But like all power tools, mocks come with a cost*. He goes on to list the benefits as well as possible issues of using mocks. Between the two extremes of too many mocks and no mocks I tend to start with no mocks until I absolutely and necessarily need one. Therefore, I am always interested in techniques that allow me the freedom of working without learning an external mocking framework. In statically typed languages like Java and C#, interface based polymorphism allows us to use mocked implementations for tests. Functional programming provides an alternative to interface based polymorphism.

Consider a problem where the quality of an item needs to be kept up to date for inventory management purposes. I am using Java in this example just because I have had to learn a Java mocking framework - [Mockito](http://mockito.org/) on a recent project. It can better illustrate the pain I've had to go through trying to learn Mockito's domain specific language and its combination of dots and parentheses. This pain is not specific to Mockito and could very well be felt for any other framework as well.

```java

public ItemUpdater(ItemRepository repository) {
  this.repository = repository;
}

public void update(Item item) {
   item.decreaseQuality();
   this.repository.save(item);
}
```

Now a repository is generally a facade over a database and is a significant architectural boundary for us to mock, ensuring tests can run faster without worrying about transferring data to and from the database. Presuming the ItemRepository is an interface, using Mockito this is the how I would write my test to ensure the item is persisted.

```java

@Test
public void ensuresUpdatedItemIsSaved() {
	ItemRepository mockedRepository = mock(ItemRepository.class);
	new ItemUpdater(mockedRepository)
	  .update(new Item("Aged Brie", 2));

	verify(mockedRepository).save(Item.class);
}
```

Although the test above establishes an item is saved but it does not ensure the correctness of that item. Mockito allows us to do that as well.

```java

@Test
public void ensuresUpdatedItemIsSaved() {
	ItemRepository mockedRepository = mock(ItemRepository.class);
	new ItemUpdater(mockedRepository)
	  .update(new Item("Aged Brie", 2));

	ArgumentCaptor<Item> argument = ArgumentCaptor
		.forClass(Item.class);
	verify(mockedRepository).save(argument.capture());
	Item item = argument.getValue();

	assertThat(item.name).isEqualTo("Aged Brie");
	assertThat(item.quality).isEqualTo(1);
}
```

The test now establishes the correctness of the item being saved but I've had to write a lot of frameworky code in order to achieve that. Apart from figuring out whether the parentheses should go before or after the 'verify' it also requires an understanding of the domain specific language of the mocking framework. Frankly the 3 lines of code before the assertion is just noise, I'd rather do without. It is just an obstruction in the way of the most important part of the test i.e. the assertion. When I or someone else revisits this test for a future change it shouldn't require navigating through all this noise to reach the assertion. So is there an alternative?

Provided the ItemRepository has a single method, as explained in a [previous post](http://hemantkumar.net/kodekitab/2015/01/04/from-object-to-function-composition.html) Single-method interfaces are easy to replace with the usage of closures and "function pointers".

```java

public class DbItemRepository implements ItemRepository {
	public void saveItem(Item item) {
		// persist to the database
	}
}

@Test
public void ensuresUpdatedItemIsSaved() {
	new ItemUpdater(item -> this.item = item)
	  .update(new Item("Aged Brie", 2));

	assertThat(this.item.name).isEqualTo("Aged Brie");
	assertThat(this.item.quality).isEqualTo(1);
}
```

With the addition of an Item member variable using a lambda expression, we've managed to remove 4 lines of code from the previous test. This is much cleaner than using Mockito and focuses on the actual test rather than the semantics of the mocking framework. The example of ItemRepository is one with a single method but what if an interface has multiple methods on it? I personally start with writing my own mock in that case. If you restrict yourself to mocking architectural boundaries like a database, web server or external service you shouldn't really need lots of mocks anyway.

Mocking tools are quite powerful and I have found them to be really useful when working with legacy code. Legacy code often uses large interfaces that violate the [Interface segregation principle](http://en.wikipedia.org/wiki/Interface_segregation_principle). Writing your own mocks for such interfaces is often painful and unwieldy as you might end up writing a mocked implementation that has tens of methods, when really you might just be interested in a single one. I,m happy to use a mocking framework to avoid writing such massive implementations myself in order to keep the tests maintainable. But I would certainly refrain from making an assumption that if I'm doing TDD or writing any sort of automated tests, I need to start with a mocking framework.
