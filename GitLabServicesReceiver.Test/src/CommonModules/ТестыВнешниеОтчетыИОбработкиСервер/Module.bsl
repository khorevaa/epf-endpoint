#Область СлужебныйПрограммныйИнтерфейс

//todo сделать тест на фэйл замены

// @unit-test
Процедура ОбновитьДанныеВХранилищеЗначенийПоИмениФайла(Фреймворк) Экспорт
	
	// given
	Выборка = Справочники.ВнешниеОбработки.Выбрать();
	Пока Выборка.Следующий() Цикл
		Обработка = Выборка.ПолучитьОбъект();
		Обработка.Удалить();
	КонецЦикла;

	ТелоФайла1 = ПолучитьДвоичныеДанныеИзСтроки("", КодировкаТекста.UTF8);	
	ТелоФайла2 = ПолучитьДвоичныеДанныеИзСтроки("ЭтоОбработка2", КодировкаТекста.UTF8);
	ТелоФайла3 = ПолучитьДвоичныеДанныеИзСтроки("ЭтоОбработка3", КодировкаТекста.UTF8);
	ТелоФайла4 = ПолучитьДвоичныеДанныеИзСтроки("ЭтоОбработка4", КодировкаТекста.UTF8);	
	
	Обработка1 = Справочники.ВнешниеОбработки.СоздатьЭлемент();
	Обработка1.Наименование = "Тест1";
	Обработка1.ВидОбработки = Перечисления.ВидыДополнительныхВнешнихОбработок.Обработка;
	Обработка1.ХранилищеВнешнейОбработки = Новый ХранилищеЗначения(ТелоФайла1);
	Обработка1.ИмяФайла = "";
	Обработка1.КомментарийКФайлуИсточнику = "";
	Обработка1.Записать();
	
	Обработка2 = Справочники.ВнешниеОбработки.СоздатьЭлемент();
	Обработка2.Наименование = "Тест2";
	Обработка2.ВидОбработки = Перечисления.ВидыДополнительныхВнешнихОбработок.Обработка;
	Обработка2.ХранилищеВнешнейОбработки = Новый ХранилищеЗначения(ТелоФайла2);
	Обработка2.ИмяФайла = "ЭтоОбработка2.epf";
	Обработка2.КомментарийКФайлуИсточнику = "Размер: ";
	Обработка2.Записать();
	
	Обработка3 = Справочники.ВнешниеОбработки.СоздатьЭлемент();
	Обработка3.Наименование = "Тест3";
	Обработка3.ВидОбработки = Перечисления.ВидыДополнительныхВнешнихОбработок.Обработка;
	НоваяПринадлежность = Обработка3.Принадлежность.Добавить();
	НоваяПринадлежность.ИмяФайлаПечатнойФормы = "ЭтоОбработка2.epf";
	НоваяПринадлежность.ХранилищеВнешнейОбработки = Новый ХранилищеЗначения(ТелоФайла2);
	НоваяПринадлежность = Обработка3.Принадлежность.Добавить();
	НоваяПринадлежность.ИмяФайлаПечатнойФормы = "ЭтоОбработка3.epf";
	НоваяПринадлежность.ХранилищеВнешнейОбработки = Новый ХранилищеЗначения(ТелоФайла3);	
	Обработка3.Записать();
	
	// when
	Результат = ВнешниеОтчетыИОбработки.ЗаменитьФайлВИнформационнойБазе("ЭтоОбработка2.epf", ТелоФайла4);
	
	// then
	Фреймворк.ПроверитьРавенство(Результат.uploaded.Количество(), 2);
	Обработка1.Прочитать();
	Обработка2.Прочитать();
	Обработка3.Прочитать();
	Фреймворк.ПроверитьРавенство(
		ПолучитьСтрокуИзДвоичныхДанных(Обработка1.ХранилищеВнешнейОбработки.Получить()),
		"");
	Фреймворк.ПроверитьРавенство(
		ПолучитьСтрокуИзДвоичныхДанных(Обработка2.ХранилищеВнешнейОбработки.Получить()),
		"ЭтоОбработка4");
	Фреймворк.ПроверитьРавенство(
		ПолучитьСтрокуИзДвоичныхДанных(Обработка3.Принадлежность[0].ХранилищеВнешнейОбработки.Получить()),
		"ЭтоОбработка4");		
	Фреймворк.ПроверитьРавенство(
		ПолучитьСтрокуИзДвоичныхДанных(Обработка3.Принадлежность[1].ХранилищеВнешнейОбработки.Получить()),
		"ЭтоОбработка3");
	
КонецПроцедуры

// @unit-test
Процедура ВключитьЗагрузкуФайлов(Фреймворк) Экспорт
	
	// given
	Константы.ЗагружатьФайлыИзВнешнегоХранилища.Установить(Ложь);

	// when
	Результат = ВнешниеОтчетыИОбработки.УстановитьЗагружатьФайлыИзВнешнегоХранилища(Истина);
	
	// then
	Фреймворк.ПроверитьРавенство(Результат.message, "загрузка файлов включена");
	Фреймворк.ПроверитьРавенство(Константы.ЗагружатьФайлыИзВнешнегоХранилища.Получить(), Истина);
	
КонецПроцедуры

// @unit-test
Процедура ВыключитьЗагрузкуФайлов(Фреймворк) Экспорт
	
	// given
	Константы.ЗагружатьФайлыИзВнешнегоХранилища.Установить(Истина);

	// when
	Результат = ВнешниеОтчетыИОбработки.УстановитьЗагружатьФайлыИзВнешнегоХранилища(Ложь);
	
	// then
	Фреймворк.ПроверитьРавенство(Результат.message, "загрузка файлов отключена");
	Фреймворк.ПроверитьРавенство(Константы.ЗагружатьФайлыИзВнешнегоХранилища.Получить(), Ложь);
	
КонецПроцедуры

#КонецОбласти