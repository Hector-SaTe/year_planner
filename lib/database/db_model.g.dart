// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetPeriodCollection on Isar {
  IsarCollection<Period> get periods => this.collection();
}

const PeriodSchema = CollectionSchema(
  name: r'Period',
  id: 7289986870337649148,
  properties: {
    r'endRange': PropertySchema(
      id: 0,
      name: r'endRange',
      type: IsarType.dateTime,
    ),
    r'startRange': PropertySchema(
      id: 1,
      name: r'startRange',
      type: IsarType.dateTime,
    ),
    r'teamList': PropertySchema(
      id: 2,
      name: r'teamList',
      type: IsarType.objectList,
      target: r'DaySet',
    ),
    r'teams': PropertySchema(
      id: 3,
      name: r'teams',
      type: IsarType.long,
    ),
    r'title': PropertySchema(
      id: 4,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _periodEstimateSize,
  serialize: _periodSerialize,
  deserialize: _periodDeserialize,
  deserializeProp: _periodDeserializeProp,
  idName: r'id',
  indexes: {
    r'startRange': IndexSchema(
      id: -7974910061567502169,
      name: r'startRange',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'startRange',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r'DaySet': DaySetSchema},
  getId: _periodGetId,
  getLinks: _periodGetLinks,
  attach: _periodAttach,
  version: '3.0.5',
);

int _periodEstimateSize(
  Period object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.teamList.length * 3;
  {
    final offsets = allOffsets[DaySet]!;
    for (var i = 0; i < object.teamList.length; i++) {
      final value = object.teamList[i];
      bytesCount += DaySetSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _periodSerialize(
  Period object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.endRange);
  writer.writeDateTime(offsets[1], object.startRange);
  writer.writeObjectList<DaySet>(
    offsets[2],
    allOffsets,
    DaySetSchema.serialize,
    object.teamList,
  );
  writer.writeLong(offsets[3], object.teams);
  writer.writeString(offsets[4], object.title);
}

Period _periodDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Period();
  object.endRange = reader.readDateTime(offsets[0]);
  object.id = id;
  object.startRange = reader.readDateTime(offsets[1]);
  object.teamList = reader.readObjectList<DaySet>(
        offsets[2],
        DaySetSchema.deserialize,
        allOffsets,
        DaySet(),
      ) ??
      [];
  object.teams = reader.readLong(offsets[3]);
  object.title = reader.readString(offsets[4]);
  return object;
}

P _periodDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readObjectList<DaySet>(
            offset,
            DaySetSchema.deserialize,
            allOffsets,
            DaySet(),
          ) ??
          []) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _periodGetId(Period object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _periodGetLinks(Period object) {
  return [];
}

void _periodAttach(IsarCollection<dynamic> col, Id id, Period object) {
  object.id = id;
}

extension PeriodQueryWhereSort on QueryBuilder<Period, Period, QWhere> {
  QueryBuilder<Period, Period, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Period, Period, QAfterWhere> anyStartRange() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'startRange'),
      );
    });
  }
}

extension PeriodQueryWhere on QueryBuilder<Period, Period, QWhereClause> {
  QueryBuilder<Period, Period, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Period, Period, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Period, Period, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Period, Period, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Period, Period, QAfterWhereClause> idBetween(
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

  QueryBuilder<Period, Period, QAfterWhereClause> startRangeEqualTo(
      DateTime startRange) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'startRange',
        value: [startRange],
      ));
    });
  }

  QueryBuilder<Period, Period, QAfterWhereClause> startRangeNotEqualTo(
      DateTime startRange) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'startRange',
              lower: [],
              upper: [startRange],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'startRange',
              lower: [startRange],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'startRange',
              lower: [startRange],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'startRange',
              lower: [],
              upper: [startRange],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Period, Period, QAfterWhereClause> startRangeGreaterThan(
    DateTime startRange, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'startRange',
        lower: [startRange],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Period, Period, QAfterWhereClause> startRangeLessThan(
    DateTime startRange, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'startRange',
        lower: [],
        upper: [startRange],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Period, Period, QAfterWhereClause> startRangeBetween(
    DateTime lowerStartRange,
    DateTime upperStartRange, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'startRange',
        lower: [lowerStartRange],
        includeLower: includeLower,
        upper: [upperStartRange],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PeriodQueryFilter on QueryBuilder<Period, Period, QFilterCondition> {
  QueryBuilder<Period, Period, QAfterFilterCondition> endRangeEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endRange',
        value: value,
      ));
    });
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> endRangeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endRange',
        value: value,
      ));
    });
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> endRangeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endRange',
        value: value,
      ));
    });
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> endRangeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endRange',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Period, Period, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Period, Period, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Period, Period, QAfterFilterCondition> startRangeEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startRange',
        value: value,
      ));
    });
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> startRangeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startRange',
        value: value,
      ));
    });
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> startRangeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startRange',
        value: value,
      ));
    });
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> startRangeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startRange',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> teamListLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'teamList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> teamListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'teamList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> teamListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'teamList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> teamListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'teamList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> teamListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'teamList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> teamListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'teamList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> teamsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'teams',
        value: value,
      ));
    });
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> teamsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'teams',
        value: value,
      ));
    });
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> teamsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'teams',
        value: value,
      ));
    });
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> teamsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'teams',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension PeriodQueryObject on QueryBuilder<Period, Period, QFilterCondition> {
  QueryBuilder<Period, Period, QAfterFilterCondition> teamListElement(
      FilterQuery<DaySet> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'teamList');
    });
  }
}

extension PeriodQueryLinks on QueryBuilder<Period, Period, QFilterCondition> {}

extension PeriodQuerySortBy on QueryBuilder<Period, Period, QSortBy> {
  QueryBuilder<Period, Period, QAfterSortBy> sortByEndRange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endRange', Sort.asc);
    });
  }

  QueryBuilder<Period, Period, QAfterSortBy> sortByEndRangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endRange', Sort.desc);
    });
  }

  QueryBuilder<Period, Period, QAfterSortBy> sortByStartRange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startRange', Sort.asc);
    });
  }

  QueryBuilder<Period, Period, QAfterSortBy> sortByStartRangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startRange', Sort.desc);
    });
  }

  QueryBuilder<Period, Period, QAfterSortBy> sortByTeams() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teams', Sort.asc);
    });
  }

  QueryBuilder<Period, Period, QAfterSortBy> sortByTeamsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teams', Sort.desc);
    });
  }

  QueryBuilder<Period, Period, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Period, Period, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension PeriodQuerySortThenBy on QueryBuilder<Period, Period, QSortThenBy> {
  QueryBuilder<Period, Period, QAfterSortBy> thenByEndRange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endRange', Sort.asc);
    });
  }

  QueryBuilder<Period, Period, QAfterSortBy> thenByEndRangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endRange', Sort.desc);
    });
  }

  QueryBuilder<Period, Period, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Period, Period, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Period, Period, QAfterSortBy> thenByStartRange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startRange', Sort.asc);
    });
  }

  QueryBuilder<Period, Period, QAfterSortBy> thenByStartRangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startRange', Sort.desc);
    });
  }

  QueryBuilder<Period, Period, QAfterSortBy> thenByTeams() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teams', Sort.asc);
    });
  }

  QueryBuilder<Period, Period, QAfterSortBy> thenByTeamsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teams', Sort.desc);
    });
  }

  QueryBuilder<Period, Period, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Period, Period, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension PeriodQueryWhereDistinct on QueryBuilder<Period, Period, QDistinct> {
  QueryBuilder<Period, Period, QDistinct> distinctByEndRange() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endRange');
    });
  }

  QueryBuilder<Period, Period, QDistinct> distinctByStartRange() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startRange');
    });
  }

  QueryBuilder<Period, Period, QDistinct> distinctByTeams() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'teams');
    });
  }

  QueryBuilder<Period, Period, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension PeriodQueryProperty on QueryBuilder<Period, Period, QQueryProperty> {
  QueryBuilder<Period, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Period, DateTime, QQueryOperations> endRangeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endRange');
    });
  }

  QueryBuilder<Period, DateTime, QQueryOperations> startRangeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startRange');
    });
  }

  QueryBuilder<Period, List<DaySet>, QQueryOperations> teamListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'teamList');
    });
  }

  QueryBuilder<Period, int, QQueryOperations> teamsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'teams');
    });
  }

  QueryBuilder<Period, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

const DaySetSchema = Schema(
  name: r'DaySet',
  id: 5968060446121009668,
  properties: {
    r'days': PropertySchema(
      id: 0,
      name: r'days',
      type: IsarType.dateTimeList,
    )
  },
  estimateSize: _daySetEstimateSize,
  serialize: _daySetSerialize,
  deserialize: _daySetDeserialize,
  deserializeProp: _daySetDeserializeProp,
);

int _daySetEstimateSize(
  DaySet object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.days.length * 8;
  return bytesCount;
}

void _daySetSerialize(
  DaySet object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTimeList(offsets[0], object.days);
}

DaySet _daySetDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DaySet();
  object.days = reader.readDateTimeList(offsets[0]) ?? [];
  return object;
}

P _daySetDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension DaySetQueryFilter on QueryBuilder<DaySet, DaySet, QFilterCondition> {
  QueryBuilder<DaySet, DaySet, QAfterFilterCondition> daysElementEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'days',
        value: value,
      ));
    });
  }

  QueryBuilder<DaySet, DaySet, QAfterFilterCondition> daysElementGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'days',
        value: value,
      ));
    });
  }

  QueryBuilder<DaySet, DaySet, QAfterFilterCondition> daysElementLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'days',
        value: value,
      ));
    });
  }

  QueryBuilder<DaySet, DaySet, QAfterFilterCondition> daysElementBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'days',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DaySet, DaySet, QAfterFilterCondition> daysLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DaySet, DaySet, QAfterFilterCondition> daysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DaySet, DaySet, QAfterFilterCondition> daysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DaySet, DaySet, QAfterFilterCondition> daysLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DaySet, DaySet, QAfterFilterCondition> daysLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DaySet, DaySet, QAfterFilterCondition> daysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension DaySetQueryObject on QueryBuilder<DaySet, DaySet, QFilterCondition> {}
