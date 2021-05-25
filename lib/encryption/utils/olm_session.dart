/*
 *   Famedly Matrix SDK
 *   Copyright (C) 2020, 2021 Famedly GmbH
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU Affero General Public License as
 *   published by the Free Software Foundation, either version 3 of the
 *   License, or (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU Affero General Public License for more details.
 *
 *   You should have received a copy of the GNU Affero General Public License
 *   along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:olm/olm.dart' as olm;

import '../../famedlysdk.dart';

class OlmSession {
  String identityKey;
  String sessionId;
  olm.Session session;
  DateTime lastReceived;
  final String key;
  String get pickledSession => session.pickle(key);

  bool get isValid => session != null;

  OlmSession({
    this.key,
    this.identityKey,
    this.sessionId,
    this.session,
    this.lastReceived,
  });

  OlmSession.fromJson(Map<String, dynamic> dbEntry, String key) : key = key {
    session = olm.Session();
    try {
      session.unpickle(key, dbEntry['pickle']);
      identityKey = dbEntry['identity_key'];
      sessionId = dbEntry['session_id'];
      lastReceived =
          DateTime.fromMillisecondsSinceEpoch(dbEntry['last_received'] ?? 0);
      assert(sessionId == session.session_id());
    } catch (e, s) {
      Logs().e('[LibOlm] Could not unpickle olm session', e, s);
      dispose();
    }
  }

  void dispose() {
    session?.free();
    session = null;
  }
}
