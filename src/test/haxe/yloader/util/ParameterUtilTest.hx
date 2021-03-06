package yloader.util;

import massive.munit.async.AsyncFactory;
import massive.munit.Assert;

import yloader.valueObject.Parameter;

class ParameterUtilTest
{
	@BeforeClass
	public function beforeClass():Void
	{
	}

	@AfterClass
	public function afterClass():Void
	{
	}

	@Before
	public function setup():Void
	{
	}

	@After
	public function tearDown():Void
	{
	}

	@Test
	public function customList_update_replacesValue():Void
	{
		var list:Array<Parameter> = [];

		ParameterUtil.update(list, new Parameter("p1", "v1"));
		ParameterUtil.update(list, new Parameter("p2", "v2"));
		ParameterUtil.update(list, new Parameter("p1", "v11"));
		ParameterUtil.update(list, new Parameter("p2", "v22"));
		ParameterUtil.update(list, new Parameter("p3", "v3"));
		ParameterUtil.update(list, new Parameter("p3", "v33"));

		Assert.areEqual(3, list.length);
		Assert.areEqual(list[0].name, "p1");
		Assert.areEqual(list[0].value, "v11");
		Assert.areEqual(list[1].name, "p2");
		Assert.areEqual(list[1].value, "v22");
		Assert.areEqual(list[2].name, "p3");
		Assert.areEqual(list[2].value, "v33");
	}

	@Test
	public function customParams_urlEncode_escapes():Void
	{
		var list:Array<Parameter> = [new Parameter("p1", "a b"), new Parameter("p 2", "a=b")];
		var result = ParameterUtil.urlEncode(list);

		Assert.areEqual(result, "p1=a%20b&p%202=a%3Db");
	}

	@Test
	public function customQueryString_fromQueryString_matches():Void
	{
		Assert.areEqual(1, ParameterUtil.fromQueryString("?test=1").length);
		Assert.areEqual("test", ParameterUtil.fromQueryString("?test=1")[0].name);
		Assert.areEqual("1", ParameterUtil.fromQueryString("?test=1")[0].value);
		Assert.areEqual("2", ParameterUtil.fromQueryString("test=2")[0].value);

		Assert.areEqual(2, ParameterUtil.fromQueryString("?foo=bar&test=3").length);
		Assert.areEqual("foo", ParameterUtil.fromQueryString("foo=bar&test=3")[0].name);
		Assert.areEqual("bar", ParameterUtil.fromQueryString("?foo=bar&test=3")[0].value);
		Assert.areEqual("test", ParameterUtil.fromQueryString("?foo=bar&test=3")[1].name);
		Assert.areEqual("3", ParameterUtil.fromQueryString("foo=bar&test=3")[1].value);

		Assert.areEqual(3, ParameterUtil.fromQueryString("?foo=bar&test=4&bar=").length);
		Assert.areEqual("4", ParameterUtil.fromQueryString("?foo=bar&test=4&bar=")[1].value);
		Assert.areEqual("", ParameterUtil.fromQueryString("?foo=bar&test=4&bar=")[2].value);

		Assert.areEqual(null, ParameterUtil.fromQueryString(""));
		Assert.areEqual(null, ParameterUtil.fromQueryString("?"));

		Assert.areEqual(1, ParameterUtil.fromQueryString("name").length);
		Assert.areEqual("name", ParameterUtil.fromQueryString("name")[0].name);
		Assert.areEqual("", ParameterUtil.fromQueryString("name")[0].value);

		Assert.areEqual("&123", ParameterUtil.fromQueryString("?test=%26123")[0].value);

		Assert.areEqual(2, ParameterUtil.fromQueryString("?foo=&bar=").length);
		Assert.areEqual("foo", ParameterUtil.fromQueryString("foo=&bar=")[0].name);
		Assert.areEqual("", ParameterUtil.fromQueryString("?foo=&bar=")[0].value);
		Assert.areEqual("bar", ParameterUtil.fromQueryString("?foo=&bar=")[1].name);
		Assert.areEqual("", ParameterUtil.fromQueryString("foo=&bar=")[1].value);

		Assert.areEqual(3, ParameterUtil.fromQueryString("?foo=1&foo=2&foo=3").length);
		Assert.areEqual("foo", ParameterUtil.fromQueryString("?foo=1&foo=2&foo=3")[0].name);
		Assert.areEqual("1", ParameterUtil.fromQueryString("?foo=1&foo=2&foo=3")[0].value);
		Assert.areEqual("foo", ParameterUtil.fromQueryString("?foo=1&foo=2&foo=3")[1].name);
		Assert.areEqual("2", ParameterUtil.fromQueryString("?foo=1&foo=2&foo=3")[1].value);
		Assert.areEqual("foo", ParameterUtil.fromQueryString("?foo=1&foo=2&foo=3")[2].name);
		Assert.areEqual("3", ParameterUtil.fromQueryString("?foo=1&foo=2&foo=3")[2].value);
	}
}