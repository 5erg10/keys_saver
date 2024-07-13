// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_credentials.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppCredentialsCollection on Isar {
  IsarCollection<AppCredentials> get appCredentials => this.collection();
}

const AppCredentialsSchema = CollectionSchema(
  name: r'AppCredentials',
  id: 3317010268606225875,
  properties: {
    r'passKey': PropertySchema(
      id: 0,
      name: r'passKey',
      type: IsarType.string,
    ),
    r'passW': PropertySchema(
      id: 1,
      name: r'passW',
      type: IsarType.string,
    ),
    r'user': PropertySchema(
      id: 2,
      name: r'user',
      type: IsarType.string,
    )
  },
  estimateSize: _appCredentialsEstimateSize,
  serialize: _appCredentialsSerialize,
  deserialize: _appCredentialsDeserialize,
  deserializeProp: _appCredentialsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _appCredentialsGetId,
  getLinks: _appCredentialsGetLinks,
  attach: _appCredentialsAttach,
  version: '3.1.0+1',
);

int _appCredentialsEstimateSize(
  AppCredentials object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.passKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.passW;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.user;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _appCredentialsSerialize(
  AppCredentials object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.passKey);
  writer.writeString(offsets[1], object.passW);
  writer.writeString(offsets[2], object.user);
}

AppCredentials _appCredentialsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppCredentials(
    passKey: reader.readStringOrNull(offsets[0]),
    passW: reader.readStringOrNull(offsets[1]),
    user: reader.readStringOrNull(offsets[2]),
  );
  object.id = id;
  return object;
}

P _appCredentialsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _appCredentialsGetId(AppCredentials object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appCredentialsGetLinks(AppCredentials object) {
  return [];
}

void _appCredentialsAttach(
    IsarCollection<dynamic> col, Id id, AppCredentials object) {
  object.id = id;
}

extension AppCredentialsQueryWhereSort
    on QueryBuilder<AppCredentials, AppCredentials, QWhere> {
  QueryBuilder<AppCredentials, AppCredentials, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppCredentialsQueryWhere
    on QueryBuilder<AppCredentials, AppCredentials, QWhereClause> {
  QueryBuilder<AppCredentials, AppCredentials, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AppCredentialsQueryFilter
    on QueryBuilder<AppCredentials, AppCredentials, QFilterCondition> {
  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      passKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'passKey',
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      passKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'passKey',
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      passKeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'passKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      passKeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'passKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      passKeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'passKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      passKeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'passKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      passKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'passKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      passKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'passKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      passKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'passKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      passKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'passKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      passKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'passKey',
        value: '',
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      passKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'passKey',
        value: '',
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      passWIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'passW',
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      passWIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'passW',
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      passWEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'passW',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      passWGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'passW',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      passWLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'passW',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      passWBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'passW',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      passWStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'passW',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      passWEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'passW',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      passWContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'passW',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      passWMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'passW',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      passWIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'passW',
        value: '',
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      passWIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'passW',
        value: '',
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      userIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'user',
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      userIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'user',
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      userEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'user',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      userGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'user',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      userLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'user',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      userBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'user',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      userStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'user',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      userEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'user',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      userContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'user',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      userMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'user',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      userIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'user',
        value: '',
      ));
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterFilterCondition>
      userIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'user',
        value: '',
      ));
    });
  }
}

extension AppCredentialsQueryObject
    on QueryBuilder<AppCredentials, AppCredentials, QFilterCondition> {}

extension AppCredentialsQueryLinks
    on QueryBuilder<AppCredentials, AppCredentials, QFilterCondition> {}

extension AppCredentialsQuerySortBy
    on QueryBuilder<AppCredentials, AppCredentials, QSortBy> {
  QueryBuilder<AppCredentials, AppCredentials, QAfterSortBy> sortByPassKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passKey', Sort.asc);
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterSortBy>
      sortByPassKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passKey', Sort.desc);
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterSortBy> sortByPassW() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passW', Sort.asc);
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterSortBy> sortByPassWDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passW', Sort.desc);
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterSortBy> sortByUser() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'user', Sort.asc);
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterSortBy> sortByUserDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'user', Sort.desc);
    });
  }
}

extension AppCredentialsQuerySortThenBy
    on QueryBuilder<AppCredentials, AppCredentials, QSortThenBy> {
  QueryBuilder<AppCredentials, AppCredentials, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterSortBy> thenByPassKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passKey', Sort.asc);
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterSortBy>
      thenByPassKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passKey', Sort.desc);
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterSortBy> thenByPassW() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passW', Sort.asc);
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterSortBy> thenByPassWDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passW', Sort.desc);
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterSortBy> thenByUser() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'user', Sort.asc);
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QAfterSortBy> thenByUserDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'user', Sort.desc);
    });
  }
}

extension AppCredentialsQueryWhereDistinct
    on QueryBuilder<AppCredentials, AppCredentials, QDistinct> {
  QueryBuilder<AppCredentials, AppCredentials, QDistinct> distinctByPassKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'passKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QDistinct> distinctByPassW(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'passW', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppCredentials, AppCredentials, QDistinct> distinctByUser(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'user', caseSensitive: caseSensitive);
    });
  }
}

extension AppCredentialsQueryProperty
    on QueryBuilder<AppCredentials, AppCredentials, QQueryProperty> {
  QueryBuilder<AppCredentials, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppCredentials, String?, QQueryOperations> passKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'passKey');
    });
  }

  QueryBuilder<AppCredentials, String?, QQueryOperations> passWProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'passW');
    });
  }

  QueryBuilder<AppCredentials, String?, QQueryOperations> userProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'user');
    });
  }
}
