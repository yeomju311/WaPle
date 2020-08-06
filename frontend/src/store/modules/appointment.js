import Vue from 'vue';
import api from '@/utils/api';

export default {
  state: {
    appointmentDialog: false, // 약속창 다이얼로그
    appointmentName: '', // 새로 만들 약속명
    groups: [], // 사용자의 그룹 목록
    group: {}, // 선택된 그룹
    appointmentDate: '', // 약속 시간
    appointments: [], // 기존에 만들어진 약속 리스트
    appointment: {}, // 선택된 그룹
    groupsThemes: [], // 유저가 속한 모든 그룹과 그 그룹에 속한 테마
  },
  getters: {
    appointmentDialog(state) {
      return state.appointmentDialog;
    },
    appointmentName(state) {
      return state.appointmentName;
    },
    groups(state) {
      return state.groups;
    },
    group(state) {
      return state.group;
    },
    appointmentDate(state) {
      return state.appointmentDate;
    },
    appointments(state) {
      return state.appointments;
    },
    appointment(state) {
      return state.appointment;
    },
    place(state, getters, rootState) {
      return rootState.place;
    },
    groupsThemes(state) {
      return state.groupsThemes;
    },
  },
  mutations: {
    trueAppointmentDialog(state) {
      state.appointmentDialog = true;
    },
    falseAppointmentDialog(state) {
      state.appointmentDialog = false;
    },
    setAppointmentName(state, payload) {
      state.appointmentName = payload.appointmentName;
    },
    setGroups(state, payload) {
      state.groups = payload.data;
    },
    setGroup(state, payload) {
      state.group = payload;
    },
    setAppointmentDate(state, payload) {
      state.appointmentDate = payload.appointmentDate;
    },
    setAppointments(state, payload) {
      state.appointments = payload.data;
    },
    setAppointment(state, payload) {
      state.appointment = payload.appointment;
    },
    setGroupsThemes(state, payload) {
      state.groupsThemes = payload.data;
    },
  },
  actions: {
    openAppointmentDialog({ commit }) {
      commit('trueAppointmentDialog'); // 창 열기
    },
    // 그룹 목록 가져옴
    getGroups({ commit }) {
      api.get(`/groups/of/${Vue.prototype.$session.get('uid')}`)
        .then(({ data }) => {
          commit('setGroups', { data });
        });
    },
    // 약속 목록 가져옴
    getAppointments({ commit }) {
      api.get(`/promises/${Vue.prototype.$session.get('uid')}`)
        .then(({ data }) => {
          commit('setAppointments', { data });
        });
    },
    closeAppointmentDialog({ commit }) {
      commit('falseAppointmentDialog'); // 창 닫기
    },
    // 선택된 값으로 업데이트 시켜줌
    updateAppointmentName({ commit }, appointmentName) {
      commit('setAppointmentName', { appointmentName });
    },
    updateGroup({ commit }, group) {
      commit('setGroup', { group });
    },
    updateAppointmentDate({ commit }, appointmentDate) {
      commit('setAppointmentDate', { appointmentDate });
    },
    updateAppointment({ commit }, appointment) {
      commit('setAppointment', { appointment });
    },
    makeAppointment({ getters }) {
      api.post('/promises', {
        groupId: getters.group.group.groupId,
        promiseDate: getters.appointmentDate,
        title: getters.appointmentName,
      }).then(({ data }) => {
        console.log(data);
        api.post('/votes', {
          groupId: getters.group.group.groupId,
          placeId: getters.place.place.placeId,
          promiseId: data,
          userId: Vue.prototype.$session.get('uid'),
        });
      });
    },
    addAppointment({ getters }) {
      api.post('/votes', {
        groupId: getters.appointment.groupId,
        placeId: getters.place.place.placeId,
        promiseId: getters.appointment.promiseId,
        userId: Vue.prototype.$session.get('uid'),
      }).then((res) => {
        console.log(res.state);
      });
    },
    getGroupsThemes({ commit }) {
      api.get(`/themes/all/${Vue.prototype.$session.get('uid')}`, {
        headers: {
          token: Vue.prototype.$session.get('token'),
        },
      }).then(({ data }) => {
        commit('setGroupsThemes', { data });
      });
    },
  },
};
